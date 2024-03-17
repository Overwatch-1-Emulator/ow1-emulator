#!mainFile "../../dev_main.opy"

#!include "heroes/kiriko/kunai.opy"
#!include "heroes/kiriko/suzu.opy"
#!include "heroes/kiriko/swift_step.opy"

playervar kiriko_self_heal_id


rule "[kiriko/init.opy]: Detect switch to Kiriko":
    @Event eachPlayer
    @Hero kiriko

    eventPlayer.call_init = true


rule "[kiriko/init.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.call_init
    
    newHero(OW1_KIRIKO_HEALTH, 0, 0)
    setUltCost(OW1_KIRIKO_ULT_COST)

    removePassiveHealing()
    startHealingModification(eventPlayer, eventPlayer, 0, HealingReeval.NONE)
    eventPlayer.kiriko_self_heal_id = getLastHealingModification()

    eventPlayer.setHealingDealt(percent(OW1_KIRKIO_OFUDA_HEALING/OW2_KIRIKO_OFUDA_HEALING))

    eventPlayer.setMaxAmmo(0, 6)
    eventPlayer.setAmmo(0, 12)
    setBaseDamage(eventPlayer, (OW1_KIRIKO_KUNAI_HEADSHOT_DAMAGE/OW2_KIRIKO_KUNAI_HEADSHOT_DAMAGE))

    eventPlayer.call_init = false


rule "[kiriko/init.opy]: Clean up Kiriko":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.KIRIKO

    waitUntil(eventPlayer.getCurrentHero() != Hero.KIRIKO, Math.INFINITY)
    stopHealingModification(eventPlayer.kiriko_self_heal_id)


rule "[kiriko/init.opy]: Deal regular damage for any non custom damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition eventAbility in [Button.MELEE]
    
    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
