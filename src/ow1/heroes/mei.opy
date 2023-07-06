#!mainFile "../../main.opy"

playervar start_freeze
playervar freeze_percent
playervar is_frozen
playervar reset_time
playervar freeze_move_percent

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
    @Condition eventAbility == Button.PRIMARY_FIRE and victim.is_frozen == false

    stopChasingVariable(victim.reset_time)
    if victim.start_freeze == false: # start the freeze time at 20
        victim.freeze_percent = 20
        victim.freeze_move_speed = 80
    if victim.freeze_percent < 100: # make sure it doesn't reset back to 20 
        victim.start_freeze = true
    victim.freeze_percent += 2.85 # 2.85% each tick from wiki
    victim.freeze_move_speed -= 2.85

rule "[mei.opy]: Freeze enemy":
    @Event playerDealtDamage
    @Hero all
    @Condition victim.freeze_percent >= 100

    victim.setStatusEffect(eventPlayer, Status.FROZEN, 1.3)
    victim.is_frozen = true
    wait(1.5)
    victim.setMoveSpeed(100)
    victim.is_frozen = false
    victim.start_freeze = false
    victim.freeze_percent = 20
    victim.freeze_move_speed = 80


rule "[mei.opy]: Slow movement":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE and victim.is_frozen == false

    if victim.freeze_move_speed >= 80:
        victim.setMoveSpeed(victim.freeze_move_speed)
    elif victim.freeze_move_speed >= 30:
        victim.setMoveSpeed(30)

rule "[mei.opy]: Start canceling slow movement freeze":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE and victim.is_frozen == false

    victim.reset_time = 1
    waitUntil(eventPlayer.isFiringPrimaryFire() == false, 9999)
    chase(victim.reset_time, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)

rule "[mei.opy]: Cancel slow movement freeze":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.reset_time == 0

    stopChasingVariable(eventPlayer.reset_time)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.freeze_percent = 20