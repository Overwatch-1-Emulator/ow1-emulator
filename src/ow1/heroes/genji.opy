#!mainFile "../../main.opy"
playervar damagetest
def initGenji():
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)

    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))

rule "[genji.opy]: Initialize Genji":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization


    initGenji()
    eventPlayer.initialized = true

rule "[genji.opy]: Change dash damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility1() == true and not eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100)
    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))    

rule "[genji.opy]: Change ult damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100)
    waitUntil(eventPlayer.isUsingUltimate() == false, 9999)
    if eventPlayer.isUsingAbility2() == true:
        waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
        eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))
    else:
    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))

rule "[genji.opy]: Change deflect damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true and not eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100)
    waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))