#!mainFile "../../dev_main.opy"

#!include "heroes/zenyatta/transc.opy"

rule "[zenyatta/init.opy]: Initialize Zenyatta":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.ZENYATTA
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_ZENYATTA_HEALTH, 0, OW1_ZENYATTA_SHIELDS)
    setUltCost(OW1_ZENYATTA_ULT_COST)
    removeSelfHealing()
    
    eventPlayer.setKnockbackDealt(percent(OW1_ZENYATTA_KNOCKBACK/OW2_ZENYATTA_KNOCKBACK))
    
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)

    eventPlayer._call_init = false


rule "[zenyatta/init.opy]: OW1 Zenyatta melee damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility == null # for some reason, zenyatta melee doesn't show up as melee
    @Condition eventPlayer.isMeleeing()

    heal(victim, null, eventDamage - (OW1_MELEE_DAMAGE/OW2_ZENYATTA_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))


rule "[zenyatta/init.opy]: Levitate with jump":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    eventPlayer.setGravity(0)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), Math.INFINITY)
    eventPlayer.setGravity(100)
