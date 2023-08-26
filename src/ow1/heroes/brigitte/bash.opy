#!mainFile "../../../main.opy"

# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation


rule "[brigitte/bash.opy]: Add stun to shield bash":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_BRIGITTE_SHIELD_BASH_STUN_DURATION)


rule "[brigitte/bash.opy]: Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setMoveSpeed(77.8) # arbitrarily decided based on trial and error
    waitUntil(not eventPlayer.isFiringPrimaryFire(), 1)
    if eventPlayer.isUsingUltimate():
        eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF))
    else:
        eventPlayer.setMoveSpeed(100)


rule "[brigitte/bash.opy]: Reduce shield bash damage to OW1":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isFiringSecondaryFire()

    heal(victim, null, OW2_BRIGITTE_SHIELD_BASH_DAMAGE - OW1_BRIGITTE_SHIELD_BASH_DAMAGE)
