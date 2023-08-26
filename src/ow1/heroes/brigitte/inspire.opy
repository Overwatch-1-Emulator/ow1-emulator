#!mainFile "../../../main.opy"

playervar inspire_duration


rule "[brigitte/inspire.opy]: Fix inspire self heal":
    @Event playerDealtDamage
    @Hero brigitte

    stopChasingVariable(eventPlayer.inspire_duration)
    eventPlayer.inspire_duration = 0
    chase(eventPlayer.inspire_duration, OW1_BRIGITTE_INSPIRE_DURATION, rate=1, ChaseReeval.NONE)
    eventPlayer.self_healing_percent = 100


rule "[brigitte/inspire.opy]: No self healing when inspire timer runs out":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.inspire_duration >= OW1_BRIGITTE_INSPIRE_DURATION

    stopChasingVariable(eventPlayer.inspire_duration)
    eventPlayer.self_healing_percent = 0
