#!mainFile "../../dev_main.opy"
playervar inspire_duration

rule "[brigitte/inspire.opy]: Inspire self healing logic":
    @Event playerDealtDamage
    @Hero brigitte

    stopChasingVariable(eventPlayer.inspire_duration)
    eventPlayer.inspire_duration = 0
    chase(eventPlayer.inspire_duration, OW1_BRIGITTE_INSPIRE_DURATION, rate=1, ChaseReeval.NONE)

    #pushSelfHealing(Button.MELEE)
    #wait(OW1_BRIGITTE_INSPIRE_DURATION, Wait.RESTART_WHEN_TRUE)
    #popSelfHealing(Button.MELEE)
