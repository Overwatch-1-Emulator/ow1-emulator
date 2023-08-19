#!mainFile "../../main.opy"

subroutine initSoldier

rule "[soldier.opy]: Initialize Soldier 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.call_initialize == true # without this flag, the reset code in generic.opy executes after initialization

    initSoldier()
    eventPlayer.call_initialize = false


def initSoldier():
    @Name "[soldier.opy]: initSoldier()"
    eventPlayer.setHealingDealt(percent(OW1_SOLDIER_BIOTIC_FIELD_HEAL/OW2_SOLDIER_BIOTIC_FIELD_HEAL))


rule "[soldier.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE)-eventDamage)