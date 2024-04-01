#!mainFile "../../ow1pp_main.opy"

#Player variables

playervar resurrect_pvar
#!defineMember countedDeadAllies resurrect_pvar[2]
#!defineMember resurrectedAllies resurrect_pvar[3]
#!defineMember deadAllies resurrect_pvar[4]
#!defineMember rezHUDIcon1 resurrect_pvar[7]
#!defineMember rezHUDIcon2 resurrect_pvar[8]


rule "[mercy/resurrect.opy]: Store dead allies in an array":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition not eventPlayer.isInSpawnRoom()
    
    do:
        eventPlayer.deadAllies = [player for player in getPlayersInRadius(worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION_AND_TRANSLATION), 15, eventPlayer.getTeam(), LosCheck.OFF) if player.isDead()]
        wait()
    while RULE_CONDITION


rule "[mercy/resurrect.opy]: Resurrection":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition len(eventPlayer.deadAllies) > 0
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isDead()
    
    eventPlayer.communicate(Comms.HELLO)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer + vect(0, 0.5, 0), 15)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer + vect(0, 1, 0), 2)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2.25)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 2000)
    eventPlayer.countedDeadAllies = 0
    eventPlayer.deadAllies.resurrectedAllies = true
    eventPlayer.deadAllies = []
    eventPlayer.setUltEnabled(false)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    wait(0.064)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    #wait this amount of time for the voiceline to finish, then immediately destroy bot
    wait(1.635)
    #to equal the time left remaining for the total waits to equal 2.25 seconds
    wait(0.551)
    eventPlayer.setUltEnabled(true)


rule "[mercy/resurrect.opy]: HUD counter":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition len(eventPlayer.deadAllies) != eventPlayer.countedDeadAllies
    @Condition not eventPlayer.isDead()
    @Condition not eventPlayer.isInSpawnRoom()
    
    do:
        eventPlayer.countedDeadAllies = len(eventPlayer.deadAllies)
        if not eventPlayer.rezHUDIcon1:
            hudSubtext(eventPlayer if len([i for i in getDeadPlayers(eventPlayer.getTeam()).exclude(eventPlayer) if distance(i.getPosition(), eventPlayer.getPosition()) <= 15]) > 0 else null, " \r\n \r\n \r\n \r\n ", HudPosition.TOP, 1, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
            eventPlayer.rezHUDIcon1 = getLastCreatedText()
        if not eventPlayer.rezHUDIcon2:
            hudSubtext(eventPlayer if len([i for i in getDeadPlayers(eventPlayer.getTeam()).exclude(eventPlayer) if distance(i.getPosition(), eventPlayer.getPosition()) <= 15]) > 0 else null, "       /  \\ \r\n     /      \\ \r\n   /  {1}×{0}\r\n  --------".format(len([i for i in getDeadPlayers(eventPlayer.getTeam()).exclude(eventPlayer) if distance(i.getPosition(), eventPlayer.getPosition()) <= 15]), iconString(Icon.SKULL)), HudPosition.TOP, 5, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
            eventPlayer.rezHUDIcon2 = getLastCreatedText()
        waitUntil(not eventPlayer.deadAllies or eventPlayer.getUltCharge() < 100, Math.INFINITY)
        destroyHudText(eventPlayer.rezHUDIcon1)
        eventPlayer.rezHUDIcon1 = null
        destroyHudText(eventPlayer.rezHUDIcon2)
        eventPlayer.rezHUDIcon2 = null
        wait()
    while RULE_CONDITION


rule "[mercy/resurrect.opy]: Resurrected player":
    @Event eachPlayer
    @Condition eventPlayer.resurrectedAllies
    
    eventPlayer.disableRespawn()
    eventPlayer.startCamera(eventPlayer.getEyePosition() + vect(0, 2, 0) + eventPlayer.getFacingDirection() * -2, eventPlayer, 0)
    eventPlayer.resurrect()
    wait()
    eventPlayer.startCamera(eventPlayer.getEyePosition(), eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 100, 3)
    kill(eventPlayer, getPlayersOnHero(Hero.MERCY, eventPlayer.getTeam()))
    wait()
    eventPlayer.resurrect()
    heal(eventPlayer, null, 99999)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 2.25)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2.25)
    eventPlayer.setStatusEffect(null, Status.BURNING, 2.25)
    playEffect(getAllPlayers(), DynamicEffect.BUFF_EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 2000)
    wait(2.25)
    eventPlayer.stopCamera()
    eventPlayer.resurrectedAllies = false
    eventPlayer.enableRespawn()


rule "[mercy/resurrect.opy]: Fix bug where rez HUD applied after death":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition eventPlayer.isDead()
    @Condition not eventPlayer.isInSpawnRoom()
    
    destroyHudText(eventPlayer.rezHUDIcon1)
    eventPlayer.rezHUDIcon1 = null
    destroyHudText(eventPlayer.rezHUDIcon2)
    eventPlayer.rezHUDIcon2 = null
    wait(0.064)
    if eventPlayer.isDead():
        goto RULE_START
