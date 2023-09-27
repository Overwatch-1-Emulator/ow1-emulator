#!mainFile "../../../main.opy"

#!include "ow1/heroes/reinhardt/firestrike.opy"
#!include "ow1/heroes/reinhardt/charge.opy"
#!include "ow1/heroes/reinhardt/shatter.opy"


rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.call_init

    resetHero()
    setCustomHealth(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
    eventPlayer.call_init = false
