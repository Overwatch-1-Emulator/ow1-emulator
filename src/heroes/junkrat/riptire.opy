#!mainFile "../../main.opy"


rule "[junkrat/riptire.opy]: OW1 Junkrat tire hp":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.isUsingUltimate()
    
    # clearCustomHp()
    # waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    # setCustomHp(OW1_JUNKRAT_HEALTH, 0, 0)
