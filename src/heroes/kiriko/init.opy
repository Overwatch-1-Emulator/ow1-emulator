#!mainFile "../../../main.opy"

# #!include "heroes/kiriko/kunai.opy"
#!include "heroes/kiriko/suzu.opy"
#!include "heroes/kiriko/step.opy"

rule "[kiriko/init.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.call_init
    
    defaultHero()
    setUltCost(OW1_KIRIKO_ULT_COST)

    removeSelfHealing()

    eventPlayer.setHealingDealt(percent(OW1_KIRKIO_OFUDA_HEALING/OW2_KIRIKO_OFUDA_HEALING))

    eventPlayer.setMaxAmmo(0, 6)
    eventPlayer.setAmmo(0, 12)
    # eventPlayer.setDamageDealt(percent(OW1_KIRIKO_GLOBAL_DAMAGE))
    eventPlayer.call_init = false


# rule "[kiriko/init.opy]: Deal regular damage for any non custom damage":
#     @Event playerDealtDamage
#     @Hero kiriko
#     @Condition eventAbility in [Button.MELEE]
    
#     damage(victim, attacker, (eventDamage/OW1_KIRIKO_GLOBAL_DAMAGE - eventDamage)/OW1_KIRIKO_GLOBAL_DAMAGE)
