#!mainFile "../../main.opy"

playervar widow_pvar
#!defineMember scoped_shot_distance widow_pvar[0]
#!defineMember scoped_damage_base widow_pvar[1]
#!defineMember ow2_scoped_damage_falloff_scalar widow_pvar[2]
#!defineMember ow1_scoped_damage_falloff_scalar widow_pvar[3]
#!defineMember expected_scoped_damage widow_pvar[4]
#!defineMember widow_armored widow_pvar[5]


# Damage falloff derived from Marblr's "How Damage Falloff is Calculated" video: https://youtu.be/VL2VnkNJPpE
#!define OW1WidowmakerN(d) ((d - OW1_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(OW1_WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - OW1_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW2WidowmakerN(d) ((d - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(OW2_WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1WidowmakerFalloff(d) ((OW1WidowmakerN(d)) * OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW1WidowmakerN(d)))
#!define OW2WidowmakerFalloff(d) ((OW2WidowmakerN(d)) * OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW2WidowmakerN(d)))


def initWidowmaker():
    @Name "[widowmaker/init.opy]: initWidowmaker()"

    setCustomHp(OW1_WIDOWMAKER_HEALTH, 0, 0)
    setUltCost(OW1_WIDOWMAKER_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    #removeSelfHealing()

rule "[widowmaker.opy]: Revert sniper damage falloff":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE

    eventPlayer.scoped_shot_distance = distance(attacker.getEyePosition(), victim)
    eventPlayer.widow_armored = victim.getHealthOfType(Health.ARMOR) > 0 and getTempShields(victim) == 0

    eventPlayer.ow2_scoped_damage_falloff_scalar = max(OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR, min(1, OW2WidowmakerFalloff(eventPlayer.scoped_shot_distance)))
    eventPlayer.ow1_scoped_damage_falloff_scalar = max(OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR, min(1, OW1WidowmakerFalloff(eventPlayer.scoped_shot_distance)))

    # Raw damage of this shot before armor, falloff and the global scalar
    eventPlayer.scoped_damage_base = (ow2ArmorRawFor(eventDamage) if eventPlayer.widow_armored else eventDamage) \
                                     / (eventPlayer.ow2_scoped_damage_falloff_scalar * eventPlayer._base_damage_scalar)
    eventPlayer.expected_scoped_damage = eventPlayer.scoped_damage_base * eventPlayer.ow1_scoped_damage_falloff_scalar

    if eventPlayer.widow_armored:
        damage(victim, attacker, ow2ArmorRawFor(ow1ArmorApplied(eventPlayer.expected_scoped_damage) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventPlayer.expected_scoped_damage - eventDamage)/eventPlayer._base_damage_scalar)

rule "[widowmaker.opy]: Compensate Widow global damage reduction":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventAbility in [Button.ABILITY_2, Button.PRIMARY_FIRE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[widowmaker/init.opy]: Compensate Ana global armor reduction":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventAbility in [Button.ABILITY_2, Button.PRIMARY_FIRE]
    @Condition victim.getHealthOfType(Health.ARMOR) > 0
    @Condition getTempShields(victim) == 0

    damage(victim, attacker, ((eventDamage + OW2_ARMOR_DAMAGE_REDUCTION) / eventPlayer._base_damage_scalar - OW1_ARMOR_DAMAGE_REDUCTION + OW2_ARMOR_DAMAGE_REDUCTION - eventDamage) / eventPlayer._base_damage_scalar)