#!mainFile "../../main.opy"

# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

rule "[brigitte/bash.opy]: Add stun to shield bash":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition attacker.isFiringSecondaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE
    # @Condition not attacker.shield_bash_through_barrier

    victim.setStatusEffect(attacker, Status.STUNNED, OW1_BRIGITTE_SHIELD_BASH_STUN_DURATION)


rule "[brigitte/bash.opy]: Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    # @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.setMoveSpeed(77.8) # arbitrarily decided based on trial and error
    waitUntil(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE) > 0, Math.INFINITY)
    if eventPlayer.isUsingUltimate():
        eventPlayer.setMoveSpeed(130)
    else:
        eventPlayer.setMoveSpeed(100)

rule "[brigitte/bash.opy]: OW1 Shield Bash Damage":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_BRIGITTE_SHIELD_BASH_DAMAGE_VS_ARMOR/OW2_BRIGITTE_SHIELD_BASH_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
#rule "[brigitte/bash.opy]: Reduce shield bash damage to OW1":
#    @Event playerDealtDamage
#    @Hero brigitte
#    @Condition eventPlayer.isFiringSecondaryFire()
#    @Condition eventAbility == Button.PRIMARY_FIRE

    #heal(victim, null, eventDamage - OW1_BRIGITTE_SHIELD_BASH_DAMAGE)
#    heal(victim, null, eventDamage - eventDamage/eventPlayer._base_damage_scalar*(OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE)+ 21)
