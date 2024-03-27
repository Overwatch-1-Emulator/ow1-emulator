#!mainFile "../../dev_main.opy"

playervar cryo_freeze_pvar
#!defineMember _cryo_enemies cryo_freeze_pvar[0]


rule "[mei/cryo_freeze.opy]: OW1 Cryo-Freeze healing":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setHealingReceived(percent(OW1_MEI_CRYO_HEALING/OW2_MEI_CRYO_HEALING))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setHealingReceived(100)


rule "[mei/cryo_freeze.opy]: Allow self healing during Cryo-Freeze":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1()

    pushSelfHealing(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    popSelfHealing(Button.ABILITY_1)


rule "[mei/cryo_freeze.opy]: Crush enemies with Cryo Freeze":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.getAltitude() > 0.5

    waitUntil(eventPlayer.isUsingAbility1() and (eventPlayer.getAltitude() <= 0.5), Math.INFINITY)

    eventPlayer._cryo_enemies = getPlayersInRadius(eventPlayer, 3, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF)
    eventPlayer._cryo_enemies = [player for player in eventPlayer._cryo_enemies if (angleBetweenVectors(Vector.DOWN, directionTowards(eventPlayer.getPosition(), player.getPosition())) < 90)]
    damage(eventPlayer._cryo_enemies, eventPlayer, 2000)
