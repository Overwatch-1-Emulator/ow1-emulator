#!mainFile "../main.opy"

# This code is copied from 
# https://workshop.codes/wiki/articles/help-my-server-is-crashing-a-guide-on-how-to-improve-server-stability-for-your-codes#anti-crash-rules


rule "[utilities/anti_crash.opy]: Activate anti crash":
    @Condition getServerLoad() > 230
    
    wait(3, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Anti crash system activated")
    setSlowMotion(10)
    waitUntil(getServerLoad() < 200, Math.INFINITY)
    setSlowMotion(100)
