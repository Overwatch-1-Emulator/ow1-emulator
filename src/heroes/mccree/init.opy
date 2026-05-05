#!mainFile "../../main.opy"

playervar cassidy_falloff_pvar
#!defineMember mccree_shot_distance          cassidy_falloff_pvar[0]
#!defineMember mccree_ow2_falloff_scalar     cassidy_falloff_pvar[1]
#!defineMember mccree_ow1_falloff_scalar     cassidy_falloff_pvar[2]
#!defineMember mccree_base_damage            cassidy_falloff_pvar[3]
#!defineMember mccree_expected_damage        cassidy_falloff_pvar[4]

#!include "flashbang.opy"
#!include "roll.opy"
#!include "deadeye.opy"

#!define OW1CassidyN(d) ((d - OW1_MCCREE_DAMAGE_FALLOFF_START_DISTANCE)/(OW1_MCCREE_DAMAGE_FALLOFF_END_DISTANCE - OW1_MCCREE_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW2CassidyPrimaryN(d) ((d - OW2_MCCREE_PRIMARY_DAMAGE_FALLOFF_START_DISTANCE)/(OW2_MCCREE_PRIMARY_DAMAGE_FALLOFF_END_DISTANCE - OW2_MCCREE_PRIMARY_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1CassidyFalloff(d) ((OW1CassidyN(d)) * OW1_MCCREE_DAMAGE_FALLOFF_START_DISTANCE + (1 - OW1CassidyN(d)))
#!define OW2CassidyFalloffPrimary(d) ((OW2CassidyPrimaryN(d)) * OW2_MCCREE_PRIMARY_DAMAGE_FALLOFF_START_DISTANCE + (1 - OW2CassidyPrimaryN(d)))




def initMccree():
    @Name "[mccree/init.opy]: initMccree()"

    setCustomHp(OW1_MCCREE_HEALTH, 0, 0)
    setUltCost(OW1_MCCREE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)

#rule "[mccree/flashbang.opy]: Compensate McCree global damage reduction":
#    @Event playerDealtDamage
#    @Hero cassidy
#    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

#    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)



rule "BLAH":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.mccree_shot_distance = distance(attacker.getEyePosition(), victim)
    if eventPlayer.mccree_shot_distance < OW1_MCCREE_DAMAGE_FALLOFF_START_DISTANCE:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
    elif eventPlayer.mccree_shot_distance < OW1_MCCREE_DAMAGE_FALLOFF_END_DISTANCE and not eventPlayer.mccree_shot_distance > OW1_MCCREE_DAMAGE_FALLOFF_END_DISTANCE:
        eventPlayer.mccree_shot_distance = eventPlayer.mccree_shot_distance/100
        damage(victim, attacker, (eventPlayer.mccree_shot_distance * 21 + (1.00 - eventPlayer.mccree_shot_distance) * OW1_MCCREE_PEACEKEEPER_DAMAGE) - eventDamage)


#rule "[cassidy/init.opy]: Revert Cassidy damage falloff":
#    @Event playerDealtDamage
#    @Hero cassidy
#    @Condition eventAbility == Button.PRIMARY_FIRE

#    eventPlayer.mccree_shot_distance = distance(attacker.getEyePosition(), victim)
#    eventPlayer.mccree_ow2_falloff_scalar = OW2CassidyFalloffPrimary(eventPlayer.mccree_shot_distance)
#    # Cap min/max scalar
#    if eventPlayer.mccree_ow2_falloff_scalar > 1: #Max damage scalar
#        eventPlayer.mccree_ow2_falloff_scalar = 1
#    elif eventPlayer.mccree_ow2_falloff_scalar < OW2_MCCREE_DAMAGE_FALLOFF_SCALAR: # Min damage scalar
#        eventPlayer.mccree_ow2_falloff_scalar = OW2_MCCREE_DAMAGE_FALLOFF_SCALAR

#    eventPlayer.mccree_base_damage = eventDamage / eventPlayer.mccree_ow2_falloff_scalar / eventPlayer._base_damage_scalar

 #   eventPlayer.mccree_ow1_falloff_scalar = OW1CassidyFalloff(eventPlayer.mccree_shot_distance)
    # Cap min/max scalar
 #   if eventPlayer.mccree_ow1_falloff_scalar > 1: # Max damage scalar
#        eventPlayer.mccree_ow1_falloff_scalar = 1
 #   elif eventPlayer.mccree_ow1_falloff_scalar < OW1_MCCREE_DAMAGE_FALLOFF_SCALAR: #Min damage scalar
#        eventPlayer.mccree_ow1_falloff_scalar = OW1_MCCREE_DAMAGE_FALLOFF_SCALAR

#    eventPlayer.mccree_expected_damage = eventPlayer.mccree_base_damage * eventPlayer.mccree_ow1_falloff_scalar


 #   damage(victim, attacker, (eventPlayer.mccree_expected_damage - eventDamage/eventPlayer._base_damage_scalar)/eventPlayer._base_damage_scalar)