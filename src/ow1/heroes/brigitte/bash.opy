#!mainFile "../../../main.opy"

# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

playervar is_using_shield_bash
playervar shield_bash_start_pos

rule "[brigitte/bash.opy]: Detect shield bash usage":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()

    waitUntil(eventPlayer.isFiringSecondaryFire() and eventPlayer.isFiringPrimaryFire(), Math.INFINITY)
    eventPlayer.is_using_shield_bash = true
    eventPlayer.shield_bash_start_pos = eventPlayer.getEyePosition()
    waitUntil(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE) > 0, Math.INFINITY)
    eventPlayer.is_using_shield_bash = false


rule "[brigitte/bash.opy]: Add stun to shield bash":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition attacker.is_using_shield_bash
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(attacker, Status.STUNNED, OW1_BRIGITTE_SHIELD_BASH_STUN_DURATION)


rule "[brigitte/bash.opy]: Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.is_using_shield_bash
    @Condition not eventPlayer.isUsingUltimate()
    
    eventPlayer.setMoveSpeed(77.8) # arbitrarily decided based on trial and error
    waitUntil(not eventPlayer.is_using_shield_bash, Math.INFINITY)
    if eventPlayer.isUsingUltimate():
        eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF))
    else:
        eventPlayer.setMoveSpeed(100)


rule "[brigitte/bash.opy]: Reduce shield bash damage to OW1":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(victim, null, OW2_BRIGITTE_SHIELD_BASH_DAMAGE - OW1_BRIGITTE_SHIELD_BASH_DAMAGE)
