#!mainFile "../../main.opy"

subroutine initGenji

rule "[genji.opy]: Initialize Genji":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization


    initGenji()
    eventPlayer.initialized = true

def initGenji():
    @Name "[genji.opy]: initGenji()"
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)

    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))

rule "[genji.opy]: Change dash damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isUsingUltimate() == false

    eventPlayer.setDamageDealt(100)
    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))    

rule "[genji.opy]: Change ult damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100)
    waitUntil(eventPlayer.isUsingUltimate() == false, 9999)
    if eventPlayer.isUsingAbility2() == true: # this code from line 35 to 39 solves this bug: if you deflect right before his ult ends, it would cause it to be using the extra damage modifier. This prevents it so if his ult ends and you are still deflecting, you wont have the extra damage until deflect is over.
        waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
        eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))
    else:
    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))

rule "[genji.opy]: Change deflect damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isUsingUltimate() == false

    eventPlayer.setDamageDealt(100)
    waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))