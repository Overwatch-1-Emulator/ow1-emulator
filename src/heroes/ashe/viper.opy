#!mainFile "../../main.opy"

playervar ashe_falloff_pvar
#!defineMember ashe_shot_distance ashe_falloff_pvar[0]
#!defineMember ashe_ow1_falloff_scalar ashe_falloff_pvar[1]

# Damage falloff derived from Marblr's "How Damage Falloff is Calculated" video: https://youtu.be/VL2VnkNJPpE
#!define OW1AsheN(d) ((d - OW1_ASHE_DAMAGE_FALLOFF_START_DISTANCE)/(OW1_ASHE_DAMAGE_FALLOFF_END_DISTANCE - OW1_ASHE_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW2AsheN(d) ((d - OW2_ASHE_DAMAGE_FALLOFF_START_DISTANCE)/(OW2_ASHE_DAMAGE_FALLOFF_END_DISTANCE - OW2_ASHE_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1AsheFalloff(d) ((OW1AsheN(d)) * OW1_ASHE_DAMAGE_FALLOFF_SCALAR + (1 - OW1AsheN(d)))
#!define OW2AsheFalloff(d) ((OW2AsheN(d)) * OW2_ASHE_DAMAGE_FALLOFF_SCALAR + (1 - OW2AsheN(d)))


rule "[ashe/init.opy]: OW1 Viper Damage Falloff":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isUsingUltimate()



    eventPlayer.ashe_shot_distance = distance(attacker.getEyePosition(), victim.getEyePosition())
    if eventPlayer.ashe_shot_distance < OW1_ASHE_DAMAGE_FALLOFF_START_DISTANCE:
        eventPlayer.ow1_true_damage = eventDamage/eventPlayer._base_damage_scalar - eventDamage
    elif eventPlayer.ashe_shot_distance <= OW1_ASHE_DAMAGE_FALLOFF_END_DISTANCE:
        eventPlayer.ashe_ow1_falloff_scalar = OW1AsheFalloff(eventPlayer.ashe_shot_distance)
        if eventPlayer.ashe_ow1_falloff_scalar > 1: eventPlayer.ashe_ow1_falloff_scalar = 1
        elif eventPlayer.ashe_ow1_falloff_scalar < OW1_ASHE_DAMAGE_FALLOFF_SCALAR: eventPlayer.ashe_ow1_falloff_scalar = OW1_ASHE_DAMAGE_FALLOFF_SCALAR
        eventPlayer.ow1_true_damage = OW1_ASHE_DAMAGE * eventPlayer.ashe_ow1_falloff_scalar - eventDamage
    else:
        eventPlayer.ow1_true_damage = OW1_ASHE_DAMAGE * OW1_ASHE_DAMAGE_FALLOFF_SCALAR - eventDamage

    damage(victim, attacker, eventPlayer.ow1_true_damage/eventPlayer._base_damage_scalar)