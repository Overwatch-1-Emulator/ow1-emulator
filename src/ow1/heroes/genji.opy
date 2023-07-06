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

rule "[genji.opy]: Test Damage GUI":
    @Event playerDealtDamage
    @Hero genji


    hudHeader(getAllPlayers(), "Damage: {0}".format(eventDamage), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

rule "[genji.opy]: Change dash damage":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageDealt(99.5)
    waitUntil(eventPlayer.isUsingAbility1() == false,9999)
    eventPlayer.setDamageDealt(percent(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE))    

