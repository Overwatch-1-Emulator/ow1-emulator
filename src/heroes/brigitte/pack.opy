#!mainFile "../../dev_main.opy"


rule "[brigitte/repair.opy]: accurate repair packs":
    @Event playerDealtHealing
    @Hero brigitte
    @Condition eventPlayer.isUsingAbility2()


    eventPlayer.A = healee
    stopHealingOverTime(getLastHealingOverTimeId())
    eventPlayer.A.startHealingOverTime(eventPlayer, 2, 55)




    #eventPlayer.A = healee
    #stopHealingOverTime(getLastHealingOverTimeId())
    #eventPlayer.A.startHealingOverTime(eventPlayer, 2, 55)
