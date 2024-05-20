#!mainFile "../../dev_main.opy"

#!include "heroes/kiriko/kunai.opy"
#!include "heroes/kiriko/suzu.opy"
#!include "heroes/kiriko/swift_step.opy"


rule "[kiriko/init.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.KIRIKO
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_KIRIKO_HEALTH, 0, 0)
    setUltCost(OW1_KIRIKO_ULT_COST)

    removeSelfHealing()

    eventPlayer.setHealingDealt(percent(OW1_KIRKIO_OFUDA_HEALING/OW2_KIRIKO_OFUDA_HEALING))

    eventPlayer.setMaxAmmo(0, 6)
    eventPlayer.setAmmo(0, 12)
    setBaseDamage(eventPlayer, (OW1_KIRIKO_KUNAI_HEADSHOT_DAMAGE/OW2_KIRIKO_KUNAI_HEADSHOT_DAMAGE))

    eventPlayer._call_init = false


rule "[kiriko/init.opy]: Deal regular damage for any non custom damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition eventAbility in [Button.MELEE]
    
    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
