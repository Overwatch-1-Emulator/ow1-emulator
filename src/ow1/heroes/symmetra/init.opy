#!mainFile "../../../main.opy"


#!include "ow1/heroes/symmetra/orb.opy"
#!include "ow1/heroes/symmetra/teleporter.opy"


rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.call_init

    newHero(OW1_SYMMETRA_HEALTH, 0, OW1_SYMMETRA_SHIELDS)
    eventPlayer.call_init = false
