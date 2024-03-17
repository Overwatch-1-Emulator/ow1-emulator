#!mainFile "../../ow1pp_main.opy"

#!include "heroes/hanzo/storm.opy"


rule "[hanzo/init.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Hero hanzo

    eventPlayer.call_init = true


rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.call_init
    
    newHero(OW1_HANZO_HEALTH, 0, 0)
    setUltCost(OW1_HANZO_ULT_COST)
    removePassiveHealing()

    eventPlayer.call_init = false


rule "[hanzo.opy]: Deal OW1 primary fire damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1]

    damage(victim, attacker, eventDamage*(OW1_HANZO_ARROW_DAMAGE/OW2_HANZO_ARROW_DAMAGE)-eventDamage)
