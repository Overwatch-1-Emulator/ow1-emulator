#!mainFile "../../main.opy"


rule "[echo/duplicate.opy]: Initialize duplicate hero":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero()

    wait(0.016)
    eventPlayer._hero_setup = eventPlayer.getHeroOfDuplication()

    resetHero()
    initHero()

    enableAllAbilities()


rule "[echo/duplicate.opy]: Reinitialize echo after exiting duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition not eventPlayer.isDuplicatingAHero()

    eventPlayer._hero_setup = eventPlayer.getCurrentHero()
    resetHero()
    initHero()


rule "[echo/duplicate.opy]: Correct duplicate ultimate charge rate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero()
    @Condition eventPlayer.getUltCharge() == 0

    wait()
    eventPlayer.setUltCharge((percent(1 - (OW2_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER/OW1_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER)))/OW2_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER)

rule "[echo/duplicate.opy]: Disallow Copy Teammates":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getUltCharge() == 100
    @Condition not eventPlayer.isDuplicatingAHero()
    @Condition eventPlayer.getRealPlayerClosestToReticle(Team.ALL) != null
    @Condition eventPlayer.getRealPlayerClosestToReticle(Team.ALL) in getPlayers(getOppositeTeam(eventPlayer.getTeam())) or distance(eventPlayer, eventPlayer.getRealPlayerClosestToReticle(Team.ALL)) > OW1_ECHO_DUPLICATE_DISTANCE

    eventPlayer.disallowButton(Button.ULTIMATE)
    waitUntil(
        eventPlayer.getRealPlayerClosestToReticle(Team.ALL) == null
        or (not (eventPlayer.getRealPlayerClosestToReticle(Team.ALL) in getPlayers(getOppositeTeam(eventPlayer.getTeam()))) and distance(eventPlayer, eventPlayer.getRealPlayerClosestToReticle(Team.ALL)) <= OW1_ECHO_DUPLICATE_DISTANCE),
        Math.INFINITY)
    eventPlayer.allowButton(Button.ULTIMATE)