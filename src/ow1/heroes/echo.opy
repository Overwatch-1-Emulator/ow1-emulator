#!mainFile "../../main.opy"

subroutine initEcho

rule "[echo.opy]: Detect Echo initialization":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initEcho()
    eventPlayer.initialized = true


def initEcho():
    @Name "[echo.opy]: initEcho()"
    # [TODO]
    pass

rule "[echo.opy]: Deal OW1 echo focusing beam under 50% hp":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventPlayer.isUsingAbility2()
    @Condition percent(victim.getHealth()/victim.getMaxHealth()) < OW1_ECHO_FOCUSING_BEAM_TRESHOLD 

    damage(victim, attacker, eventDamage*(OW1_ECHO_FOCUSING_BEAM_DMG/OW2_ECHO_FOCUSING_BEAM_DMG)-eventDamage)
