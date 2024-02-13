#!mainFile "../../main.opy"

#!include "heroes/soldier/pulse_rifle.opy"
#!include "heroes/soldier/biotic_field.opy"


rule "[soldier/init.opy]: Detect switch to Soldier 76":
    @Event eachPlayer
    @Hero soldier

    eventPlayer.call_init = true


rule "[soldier/init.opy]: Initialize Soldier 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.call_init

    newHero(OW1_SOLDIER_HEALTH, 0, 0)
    setUltCost(OW1_SOLDIER_ULT_COST)
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))
    removeSelfHealing()

    eventPlayer.call_init = false
