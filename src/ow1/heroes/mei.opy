#!mainFile "../../main.opy"

playervar freeze_progress
playervar is_frozen
playervar freeze_slow_linger_time
playervar freeze_move_penalty

subroutine initMei
subroutine clearFreezeEffect

rule "[mei.opy]: Detect Mei initialization":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMei()
    eventPlayer.initialized = true


def initMei():
    @Name "[mei.opy]: initMei()"
    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)


rule "[mei.opy]: Track freezing on enemy":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition victim.freeze_progress < 100

    stopChasingVariable(victim.freeze_slow_linger_time)

    if victim.freeze_progress == 0: # victims started taking freeze damage
        victim.freeze_progress = OW1_MEI_MINIMUM_FREEZE
    else:
        victim.freeze_progress += OW1_MEI_FREEZE_PERCENT_PER_TICK # 2.85% each tick from wiki

    victim.freeze_move_penalty = victim.freeze_progress if victim.freeze_progress < OW1_MEI_FREEZE_MAX_SLOW else OW1_MEI_FREEZE_MAX_SLOW
    # victim.setMoveSpeed(100-victim.freeze_move_penalty)
    
    victim.freeze_slow_linger_time = 0
    chase(victim.freeze_slow_linger_time, OW1_MEI_FREEZE_SLOW_LINGER_DURATION, rate=1, ChaseReeval.NONE)


rule "[mei.opy]: Freeze enemy":
    @Event playerTookDamage
    @Hero all
    @Condition victim.freeze_progress >= 100

    victim.setStatusEffect(eventPlayer, Status.FROZEN, OW1_MEI_FREEZE_DURATION)
    waitUntil(victim.hasStatusEffect(Status.FROZEN) == false, 9999)
    clearFreezeEffect()
    

rule "[mei.opy]: clear freeze after exceeding linger time":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freeze_slow_linger_time >= OW1_MEI_FREEZE_SLOW_LINGER_DURATION

    clearFreezeEffect()


def clearFreezeEffect():
    @Name "[mei.opy]: clearFreezeEffect()"
    
    stopChasingVariable(eventPlayer.freeze_slow_linger_time)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.freeze_progress = 0
    
