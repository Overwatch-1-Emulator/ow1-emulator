#!mainFile "../main.opy"

globalvar antiCrashActivated


rule "[utilities/anti_crash.opy]: anti crash":
    @Condition antiCrashActivated == false
    @Condition getServerLoad() > 230
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Anti crash system activated")
    setSlowMotion(10)
    antiCrashActivated = true


rule "[utilities/anti_crash.opy]: disable anti crash":
    @Condition antiCrashActivated == true
    @Condition getServerLoad() < 200
    
    setSlowMotion(100)
    antiCrashActivated = false
