#!mainFile "../../dev_main.opy"


# rule "[lucio/soundwave.opy]: OW1 Soundwave damage":
#     @Event playerDealtDamage
#     @Hero lucio
#     @Condition eventAbility == Button.SECONDARY_FIRE

#     damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_LUCIO_SOUNDWAVE_DAMAGE/OW2_LUCIO_SOUNDWAVE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
