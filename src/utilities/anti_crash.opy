#!mainFile "../main.opy"

# This code is copied from 
# https://workshop.codes/wiki/articles/help-my-server-is-crashing-a-guide-on-how-to-improve-server-stability-for-your-codes#anti-crash-rules


globalvar antiCrashActivated


rule "[utilities/anti_crash.opy]: anti crash":
    @Condition antiCrashActivated == false
    @Condition getServerLoad() > 230
    
    wait(3, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Anti crash system activated")
    setSlowMotion(10)
    antiCrashActivated = true


rule "[utilities/anti_crash.opy]: disable anti crash":
    @Condition antiCrashActivated == true
    @Condition getServerLoad() < 200
    
    setSlowMotion(100)
    antiCrashActivated = false
