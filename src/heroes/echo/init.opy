#!mainFile "../../main.opy"

#!include "focusing_beam.opy"
#!include "duplicate.opy"
# !include "newduplicate.opy"

def initEcho():
    @Name "[echo/init.opy]: initEcho()"

    setCustomHp(OW1_ECHO_HEALTH-1, 0, 0) # Need to subtract 1 because of extra 1 shield health
    setUltCost(OW1_ECHO_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
