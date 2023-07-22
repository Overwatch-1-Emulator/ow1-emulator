#!mainFile "../../main.opy"

subroutine initHanzo

rule "[hanzo.opy]: Detect Hanzo initialization":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initHanzo()
    eventPlayer.initialized = true

def initHanzo():
    @Name "[hanzo.opy]: initHanzo()"
    # [TODO]
    pass

rule "[hanzo.opy]: Deal OW1 storm arrow damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, eventDamage*(OW1_HANZO_STORM_DAMAGE/OW2_HANZO_STORM_DAMAGE)-eventDamage)