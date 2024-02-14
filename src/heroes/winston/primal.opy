#!mainFile "../../main.opy"


rule "[winston/primal.opy]: Fix primal rage hp":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    
    setCustomHp(OW1_WINSTON_PRIMAL_HEALTH, OW1_WINSTON_PRIMAL_ARMOR, 0)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    setCustomHp(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)
