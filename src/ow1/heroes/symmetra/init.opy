#!mainFile "../../../main.opy"


#!include "ow1/heroes/symmetra/orb.opy"
#!include "ow1/heroes/symmetra/teleporter.opy"


rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.call_init

    resetHero()
    eventPlayer.call_init = false
