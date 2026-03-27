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




#rule "[brigitte/bash.opy]: Reduce shield bash damage to OW1":
#    @Event playerDealtDamage
#    @Hero brigitte
#    @Condition eventPlayer.isFiringSecondaryFire()
#    @Condition eventAbility == Button.PRIMARY_FIRE

    #heal(victim, null, eventDamage - OW1_BRIGITTE_SHIELD_BASH_DAMAGE)
#    heal(victim, null, eventDamage - eventDamage/eventPlayer._base_damage_scalar*(OW1_BRIGITTE_SHIELD_BASH_DAMAGE/OW2_BRIGITTE_SHIELD_BASH_DAMAGE)+ 21)
