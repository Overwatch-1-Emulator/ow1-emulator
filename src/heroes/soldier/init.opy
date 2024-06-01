#!mainFile "../../dev_main.opy"

#!include "heroes/soldier/pulse_rifle.opy"
#!include "heroes/soldier/biotic_field.opy"


def initSoldier():
    @Name "[soldier/init.opy]: initSoldier()"

    setCustomHp(OW1_SOLDIER_HEALTH, 0, 0)
    setUltCost(OW1_SOLDIER_ULT_COST)
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))
    removeSelfHealing()


rule "[soldier/init.opy]: Initialize Soldier 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer._call_init

    initSoldier()
    eventPlayer._call_init = false
