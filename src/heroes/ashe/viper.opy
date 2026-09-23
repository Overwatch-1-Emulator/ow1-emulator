#!mainFile "../../main.opy"

playervar ashe_falloff_pvar
#!defineMember _ashe_shot_distance ashe_falloff_pvar[0]
#!defineMember _ashe_ow1_falloff_scalar ashe_falloff_pvar[1]
#!defineMember _ashe_target_damage ashe_falloff_pvar[2]
#!defineMember _ashe_ow2_falloff_scalar ashe_falloff_pvar[3]
#!defineMember _ashe_armored ashe_falloff_pvar[4]
#!defineMember _ashe_hit_multiplier ashe_falloff_pvar[5]

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



    eventPlayer._ashe_shot_distance = distance(attacker.getEyePosition(), victim.getEyePosition())
    eventPlayer._ashe_armored = victim.getHealthOfType(Health.ARMOR) > 0 and getTempShields(victim) == 0 and eventDamage > 0

    eventPlayer._ashe_ow2_falloff_scalar = max(OW2_ASHE_DAMAGE_FALLOFF_SCALAR, min(1, OW2AsheFalloff(eventPlayer._ashe_shot_distance)))
    eventPlayer._ashe_hit_multiplier = (ow2ArmorRawFor(eventDamage) if eventPlayer._ashe_armored else eventDamage) \
                                      / (OW2_ASHE_DAMAGE * eventPlayer._ashe_ow2_falloff_scalar * eventPlayer._base_damage_scalar)

    eventPlayer._ashe_ow1_falloff_scalar = max(OW1_ASHE_DAMAGE_FALLOFF_SCALAR, min(1, OW1AsheFalloff(eventPlayer._ashe_shot_distance)))
    eventPlayer._ashe_target_damage = OW1_ASHE_DAMAGE * eventPlayer._ashe_ow1_falloff_scalar * eventPlayer._ashe_hit_multiplier

    if eventPlayer._ashe_armored:
        damage(victim, attacker, ow2ArmorRawFor(floor(ow1ArmorApplied(eventPlayer._ashe_target_damage)) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventPlayer._ashe_target_damage - eventDamage)/eventPlayer._base_damage_scalar)