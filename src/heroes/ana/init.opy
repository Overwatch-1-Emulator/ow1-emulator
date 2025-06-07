#!mainFile "../../dev_main.opy"

# !include "sleep.opy"
#!include "nade.opy"

def initAna():
    @Name "[ana/init.opy]: initAna()"

    setCustomHp(OW1_ANA_HEALTH, 0, 0)
    setUltCost(OW1_ANA_ULT_COST)
    removeSelfHealing()

    eventPlayer.setAmmo(0, OW1_ANA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ANA_CLIP_SIZE)

    setBaseDamage(eventPlayer, OW1_ANA_BIOTIC_GRENADE_DAMAGE/OW2_ANA_BIOTIC_GRENADE_DAMAGE)


rule "[ana/init.opy]: OW1 Ana rifle damage":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility in [Button.PRIMARY_FIRE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ANA_BIOTIC_RIFLE_DAMAGE/OW2_ANA_BIOTIC_RIFLE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
