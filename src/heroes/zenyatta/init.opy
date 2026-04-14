#!mainFile "../../main.opy"

# !include "transc.opy"

def initZenyatta():
    @Name "[zenyatta/init.opy]: initZenyatta()"

    setCustomHp(OW1_ZENYATTA_HEALTH, 0, OW1_ZENYATTA_SHIELDS)
    setUltCost(OW1_ZENYATTA_ULT_COST)
    #removeSelfHealing()

    eventPlayer.setKnockbackDealt(percent(OW1_ZENYATTA_KNOCKBACK/OW2_ZENYATTA_KNOCKBACK))
    setBaseDamage(eventPlayer, 1/OW2_ZENYATTA_MELEE_DAMAGE)

    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)



rule "[zenyatta/init.opy]: OW1 Zenyatta Orb Damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ZENYATTA_ORB_DAMAGE_VS_ARMOR/OW2_ZENYATTA_ORB_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ZENYATTA_ORB_DAMAGE/OW2_ZENYATTA_ORB_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)