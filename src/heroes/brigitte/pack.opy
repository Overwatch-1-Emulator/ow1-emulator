#!mainFile "../../dev_main.opy"


rule "[brigitte/repair.opy]: accurate repair packs":
    @Event playerDealtHealing
    @Hero brigitte
    @Condition eventAbility == Button.ABILITY_2

    eventPlayer.A = healee
    stopHealingOverTime(getLastHealingOverTimeId())
    eventPlayer.A.startHealingOverTime(eventPlayer, 2, 55)