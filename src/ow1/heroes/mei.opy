#!mainFile "../../main.opy"

playervar startFreeze
playervar freeze_time
playervar isFrozen

def initMei():
    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)

rule "[mei.opy]: Initialize Mei":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMei()
    eventPlayer.initialized = true

rule "[mei.opy] Freeze enemy": # credit to snappycreeper for this rule
    @Event playerDealtDamage
    @Hero mei
    @Condition eventPlayer.isFiringPrimaryFire() == true and victim.isFrozen == false

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if victim.startFreeze == false:
        victim.freeze_time = 20
    if victim.freeze_time < 100:
        victim.startFreeze = true
    victim.freeze_time += 2.85
    if victim.freeze_time <= 70:
        victim.setMoveSpeed(victim.freeze_time)
    if victim.freeze_time >= 100:
        victim.setStatusEffect(eventPlayer, Status.FROZEN, 1.3)
        victim.isFrozen = true
        wait(1.5)
        victim.setMoveSpeed(100)
        victim.isFrozen = false
        victim.startFreeze = false
        victim.freeze_time = 20

rule "[mei.opy] Cancel freeze":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventPlayer.isFiringPrimaryFire() == true and victim.isFrozen == false

    
    waitUntil(eventPlayer.isFiringPrimaryFire() == false, 9999)
    wait(1,Wait.RESTART_WHEN_TRUE)
    victim.setMoveSpeed(100)
    victim.freeze_time = 20