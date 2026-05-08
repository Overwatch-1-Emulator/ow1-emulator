#!mainFile "../../main.opy"

playervar cassidy_falloff_pvar
#!defineMember mccree_shot_distance          cassidy_falloff_pvar[0]
#!defineMember mccree_ow1_falloff_scalar     cassidy_falloff_pvar[1]

#!include "flashbang.opy"
#!include "roll.opy"
#!include "deadeye.opy"

#!define OW1CassidyN(d) ((d - OW1_MCCREE_DAMAGE_FALLOFF_START_DISTANCE)/(OW1_MCCREE_DAMAGE_FALLOFF_END_DISTANCE - OW1_MCCREE_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1CassidyFalloff(d) ((OW1CassidyN(d)) * OW1_MCCREE_DAMAGE_FALLOFF_SCALAR + (1 - OW1CassidyN(d)))





def initMccree():
    @Name "[mccree/init.opy]: initMccree()"

    setCustomHp(OW1_MCCREE_HEALTH, 0, 0)
    setUltCost(OW1_MCCREE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)

    

    #eventPlayer.disallowButton(Button.ABILITY_2)

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
    elif eventPlayer.mccree_shot_distance <= OW1_MCCREE_DAMAGE_FALLOFF_END_DISTANCE:
        eventPlayer.mccree_ow1_falloff_scalar = OW1CassidyFalloff(eventPlayer.mccree_shot_distance)
        if eventPlayer.mccree_ow1_falloff_scalar > 1: eventPlayer.mccree_ow1_falloff_scalar = 1
        elif eventPlayer.mccree_ow1_falloff_scalar < OW1_MCCREE_DAMAGE_FALLOFF_SCALAR: eventPlayer.mccree_ow1_falloff_scalar = OW1_MCCREE_DAMAGE_FALLOFF_SCALAR
        damage(victim, attacker, (OW1_MCCREE_PEACEKEEPER_DAMAGE * eventPlayer.mccree_ow1_falloff_scalar - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (OW1_MCCREE_PEACEKEEPER_DAMAGE * OW1_MCCREE_DAMAGE_FALLOFF_SCALAR - eventDamage)/eventPlayer._base_damage_scalar)