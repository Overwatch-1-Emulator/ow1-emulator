# Credit to oreoslurpee for Brigitte shield bash stun logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

#!include "ow1_constants.opy"

rule "Add stun to shield bash":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, ow1_shield_bash_stun_duration)

rule "Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setMoveSpeed(60)
    wait(0.3)
    if not eventPlayer.isUsingUltimate():
        eventPlayer.setMoveSpeed(100)
    else:
        eventPlayer.setMoveSpeed(113.043)

rule "Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(percent(ow1_rally_speed_buff/ow2_rally_speed_buff)) # 30% movement speed buff during ralley
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setMoveSpeed(100)

rule "debug":
    @Event eachPlayer
    @Hero brigitte

    hudText(eventPlayer, "{0}".format(eventPlayer.getSpeed()), "", "", HudPosition.TOP, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.STRING)