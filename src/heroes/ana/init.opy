#!mainFile "../../ow1pp_main.opy"

#!include "heroes/ana/sleep.opy"
#!include "heroes/ana/nade.opy"

rule "[ana/init.opy]: Detect switch to Ana":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[ana/init.opy]: Initialize Ana":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.call_init == true
    
    newHero(OW1_ANA_HEALTH, 0, 0)
    setUltCost(OW1_ANA_ULT_COST)
    removePassiveHealing()

    eventPlayer.setAmmo(0, OW1_ANA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ANA_CLIP_SIZE)

    setBaseDamage(eventPlayer, OW1_ANA_BIOTIC_GRENADE_DAMAGE/OW2_ANA_BIOTIC_GRENADE_DAMAGE)

    eventPlayer.call_init = false


rule "[ana/init.opy]: Correct rifle and sleep dart damage":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
