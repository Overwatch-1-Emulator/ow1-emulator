#!mainFile "../../main.opy"

playervar dmg_done_while_ult_active
playervar start_time_ult
subroutine initAshe

rule "[ashe.opy]: Detect Ashe initialization":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initAshe()
    eventPlayer.initialized = true


def initAshe():
    @Name "[ashe.opy]: initAshe()"
    # [TODO]
    pass


rule "[ashe.opy]: Add ultimate charge while using BOB":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.dmg_done_while_ult_active = 0
    eventPlayer.start_time_ult = getTotalTimeElapsed()

    waitUntil(eventPlayer.isUsingUltimate() == false, 99999)
    # Check if the user did not switch hero after using B.O.B to add the ult charge
    if eventPlayer.getCurrentHero() == Hero.ASHE :
        # Add charge for passive generation and then the ult charge generated from the damage made by Ashe
        eventPlayer.setUltCharge(percent((ULT_CHARGE_PER_SECOND * (getTotalTimeElapsed() - eventPlayer.start_time_ult) + eventPlayer.dmg_done_while_ult_active) / OW1_ASHE_ULT_COST)) 
 


rule "[ashe.opy]: Calcul of the damage made while BOB is active":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition victim != attacker

    eventPlayer.dmg_done_while_ult_active += eventDamage