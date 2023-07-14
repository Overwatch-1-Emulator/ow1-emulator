#!mainFile "../../main.opy"

subroutine initSoldier

rule "[soldier.opy]: Initialize Soldier 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSoldier()
    eventPlayer.initialized = true


def initSoldier():
    @Name "[soldier.opy]: initSoldier()"
    # [TODO]
    pass


rule "[soldier.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE)-eventDamage)