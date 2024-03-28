#!mainFile "../../dev_main.opy"

#!include "heroes/zenyatta/transc.opy"

rule "[zenyatta/init.opy]: Detect switch to Zenyatta":
    @Event eachPlayer
    @Hero zenyatta

    eventPlayer.call_init = true


rule "[zenyatta/init.opy]: Initialize Zenyatta":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.call_init
    
    newHero(OW1_ZENYATTA_HEALTH, 0, OW1_ZENYATTA_SHIELDS)
    setUltCost(OW1_ZENYATTA_ULT_COST)
    removePassiveHealing()
    
    eventPlayer.setKnockbackDealt(percent(OW1_ZENYATTA_KNOCKBACK/OW2_ZENYATTA_KNOCKBACK))
    
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)

    eventPlayer.call_init = false


rule "[zenyatta/init.opy]: OW1 Zenyatta melee damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility == null # for some reason, zenyatta melee doesn't show up as melee
    @Condition eventPlayer.isMeleeing()

    heal(victim, null, eventDamage - (OW1_MELEE_DAMAGE/OW2_ZENYATTA_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))
