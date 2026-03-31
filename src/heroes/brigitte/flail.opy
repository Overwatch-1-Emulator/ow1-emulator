#!mainFile "../../main.opy"



rule "brigitte/flail.opy: OW1 flail damage":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventPlayer.isFiringSecondaryFire()

        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
