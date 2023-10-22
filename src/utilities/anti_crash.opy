#!mainFile "../main.opy"

# This code is copied from 
# https://workshop.codes/wiki/articles/help-my-server-is-crashing-a-guide-on-how-to-improve-server-stability-for-your-codes#anti-crash-rules

globalvar ANTI_CRASH_SERVER_PERCENT = createWorkshopSetting(int[0:250], "Lobby", "Anti Crash Percent", 200)
globalvar ANTI_CRASH_SERVER_SUSTAIN = createWorkshopSetting(int[0:20], "Lobby", "Anti Crash Sustain", 8)

rule "[anti_crash.opy]: Activate anti crash":
    @Condition getServerLoad() > ANTI_CRASH_SERVER_PERCENT
    
    wait(ANTI_CRASH_SERVER_SUSTAIN, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Anti crash system activated")
    setSlowMotion(10)
    waitUntil(getServerLoad() < 150, Math.INFINITY)
    setSlowMotion(100)
