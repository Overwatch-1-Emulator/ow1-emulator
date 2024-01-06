#!mainFile "../../main.opy"

rule "[soldier/init.opy]: Detect switch to Soldier 76":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[soldier/init.opy]: Initialize Soldier 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.call_init

    defaultHero()
    setUltCost(OW1_SOLDIER_ULT_COST)
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))
    eventPlayer.call_init = false


rule "[soldier.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE)-eventDamage)
