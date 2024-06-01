#!mainFile "../../dev_main.opy"

#!include "heroes/ramattra/nemesis.opy"
#!include "heroes/ramattra/vortex.opy"


def initRamattra():
    @Name "[ramattra/init.opy]: initRamattra()"

    setCustomHp(OW1_RAMATTRA_HEALTH, OW1_RAMATTRA_ARMOR, OW1_RAMATTRA_SHIELDS)
    setUltCost(OW1_RAMATTRA_ULT_COST)

    removeTankPassive()
    removeSelfHealing()
    

rule "[ramattra/init.opy]: Initialize Ramattra":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer._call_init

    initRamattra()
    eventPlayer._call_init = false
