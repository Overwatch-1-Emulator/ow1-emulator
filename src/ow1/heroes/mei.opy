#!mainFile "../../main.opy"

playervar start_freeze
playervar freeze_percent
playervar is_frozen
playervar freeze_slow_effect_timer
playervar freeze_penalty_percent

subroutine initMei

rule "[mei.opy]: Initialize Mei":
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
    @Condition eventAbility == Button.PRIMARY_FIRE and victim.is_frozen == false

    stopChasingVariable(victim.freeze_slow_effect_timer)
    victim.freeze_slow_effect_timer = 1
    if victim.start_freeze == false: # start the freeze time at 20
        victim.freeze_percent = OW1_MEI_MINIMUM_FREEZE
    if victim.freeze_percent < 100: # make sure it doesn't reset back to 20 
        victim.start_freeze = true
    victim.freeze_percent += OW1_MEI_FREEZE_PERCENT_PER_TICK # 2.85% each tick from wiki
    if victim.freeze_percent <= OW1_MEI_FREEZE_MAX_SLOW:
        victim.freeze_penalty_percent = victim.freeze_percent
    victim.setMoveSpeed(100-victim.freeze_penalty_percent)
    chase(victim.freeze_slow_effect_timer, 0, rate=1, ChaseReeval.NONE)


rule "[mei.opy]: Freeze enemy":
    @Event playerDealtDamage
    @Hero all
    @Condition victim.freeze_percent >= 100

    victim.setStatusEffect(eventPlayer, Status.FROZEN, OW1_MEI_FREEZE_DURATION)
    victim.is_frozen = true
    wait(OW1_MEI_FREEZE_DURATION)
    victim.is_frozen = false
    victim.start_freeze = false
    victim.freeze_percent = OW1_MEI_MINIMUM_FREEZE
    victim.setMoveSpeed(100)
    

rule "[mei.opy]: Cancel slow movement freeze":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freeze_slow_effect_timer == 0

    stopChasingVariable(eventPlayer.freeze_slow_effect_timer)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.freeze_percent = OW1_MEI_MINIMUM_FREEZE