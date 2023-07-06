#!mainFile "../../main.opy"

playervar start_freeze
playervar freeze_percent
playervar is_frozen
playervar reset_time

def initMei():
    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)

rule "[mei.opy]: Initialize Mei":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMei()
    eventPlayer.initialized = true

rule "[mei.opy]: Track freezing on enemy":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventPlayer.isFiringPrimaryFire() == true and victim.is_frozen == false

    stopChasingVariable(victim.reset_time)
    wait(0.016, Wait.ABORT_WHEN_FALSE) # wait 0.016 is 1 tick
    if victim.start_freeze == false: # start the freeze time at 20
        victim.freeze_percent = 20
    if victim.freeze_percent < 100: # make sure it doesn't reset back to 20 
        victim.start_freeze = true
    victim.freeze_percent += 2.85 # 2.85% each tick from wiki
    if victim.freeze_percent <= 70: # make sure you can only max freeze 70% movement speed
        victim.setMoveSpeed(victim.freeze_percent)

rule "[mei.opy]: Freeze enemy":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventPlayer.isFiringPrimaryFire() == true and victim.is_frozen == false

    if victim.freeze_percent >= 100: # if its above 100, freeze em!
        victim.setStatusEffect(eventPlayer, Status.FROZEN, 1.3)
        victim.is_frozen = true
        wait(1.5)
        victim.setMoveSpeed(100)
        victim.is_frozen = false
        victim.start_freeze = false
        victim.freeze_percent = 20

rule "[mei.opy]: Start canceling slow movement freeze":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventPlayer.isFiringPrimaryFire() == true and victim.is_frozen == false

    victim.reset_time = 5
    waitUntil(eventPlayer.isFiringPrimaryFire() == false, 9999)
    chase(victim.reset_time, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)

rule "[mei.opy]: Cancel slow movement freeze":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.reset_time == 0

    stopChasingVariable(eventPlayer.reset_time)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.freeze_percent = 20