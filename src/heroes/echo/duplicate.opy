#!mainFile "../../dev_main.opy"


rule "[echo/duplicate.opy]: Initialize duplicate hero":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero()
    
    eventPlayer._hero_setup = eventPlayer.getHeroOfDuplication()
    resetHero()
    initHero()
    
    resetSelfHealing()
    removePassiveHealing()
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
