#!mainFile "../main.opy"

# Following code is based on 
# https://workshop.codes/wiki/articles/help-my-server-is-crashing-a-guide-on-how-to-improve-server-stability-for-your-codes#anti-crash-rules

globalvar ANTI_CRASH_ACTIVATE_PERCENT = createWorkshopSetting(int[0:250], "Anti Crash", "Activation Percent", 200)
globalvar ANTI_CRASH_HOLD_TIME = createWorkshopSetting(float[0:20], "Anti Crash", "Activation Hold Time", 5.5)
globalvar ANTI_CRASH_DEACTIVATE_PERCENT = createWorkshopSetting(int[0:250], "Anti Crash", "Deactivation Percent", 110)

rule "[utilities/anti_crash.opy]: Activate anti crash":
    @Condition getServerLoad() > ANTI_CRASH_ACTIVATE_PERCENT

    wait(ANTI_CRASH_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    smallMessage(getAllPlayers(), "Crash protection in progress...")
    setSlowMotion(1)
    waitUntil(getServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT, Math.INFINITY)
    setSlowMotion(100)
