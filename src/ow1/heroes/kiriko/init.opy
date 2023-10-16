#!mainFile "../../../main.opy"

# #!include "ow1/heroes/kiriko/kunai.opy"
#!include "ow1/heroes/kiriko/suzu.opy"
#!include "ow1/heroes/kiriko/step.opy"

rule "[kiriko/init.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.call_init
    
    eventPlayer.setAbility2Enabled(false)
    resetStats()
    resetStatuses()
    resetFrenemies()
    resetUltCharge()
    clearCustomHealth()
    resetSelfHealing()
    setCustomHealth(OW1_KIRIKO_HEALTH, 0, 0)
    resetAbilities()
    # eventPlayer.setHealingDealt(percent(OW1_KIRKIO_OFUDA_HEALING/OW2_KIRKIO_OFUDA_HEALING))
    removeSelfHealing()
    # eventPlayer.setDamageDealt(percent(OW1_KIRIKO_GLOBAL_DAMAGE))
    eventPlayer.call_init = false


# rule "[kiriko/init.opy]: Deal regular damage for any non custom damage":
#     @Event playerDealtDamage
#     @Hero kiriko
#     @Condition eventAbility in [Button.MELEE]
    
#     damage(victim, attacker, (eventDamage/OW1_KIRIKO_GLOBAL_DAMAGE - eventDamage)/OW1_KIRIKO_GLOBAL_DAMAGE)
