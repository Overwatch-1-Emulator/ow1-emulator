#!mainFile "../../main.opy"

playervar freeze_progress
playervar mei_pvar
# getTotalTimeElapsed() when freeze progress expires
#!defineMember freeze_linger_end_time mei_pvar[0]
#!defineMember freeze_move_penalty mei_pvar[1]

#!defineMember blaster_damage_range mei_pvar[2]

subroutine clearFreezeEffect


rule "[mei/blaster.opy]: Track freezing on enemy":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventPlayer.blaster_damage_range > OW1_MEI_ENDOTHERMIC_BLASTER_RANGE # Account for Endothermic Blaster range
    @Condition victim.freeze_progress < 100

    if victim.freeze_progress == 0: # victims started taking freeze damage
        victim.freeze_progress = OW1_MEI_MINIMUM_FREEZE
    else:
        victim.freeze_progress += OW1_MEI_FREEZE_PERCENT_PER_TICK # 2.85% each tick from wiki

    victim.freeze_move_penalty = victim.freeze_progress if victim.freeze_progress < OW1_MEI_FREEZE_MAX_SLOW else OW1_MEI_FREEZE_MAX_SLOW
    # victim.setMoveSpeed(100-victim.freeze_move_penalty)

    victim.freeze_linger_end_time = getTotalTimeElapsed() + OW1_MEI_FREEZE_SLOW_LINGER_DURATION


rule "[mei/blaster.opy]: Freeze enemy":
    @Event playerTookDamage
    @Hero all
    @Condition victim.freeze_progress >= 100

    victim.setStatusEffect(eventPlayer, Status.FROZEN, 1*OW1_MEI_FREEZE_DURATION) # 1x feels too short for some reason
    waitUntil(not victim.hasStatusEffect(Status.FROZEN), Math.INFINITY)
    clearFreezeEffect()


rule "[mei/blaster.opy]: clear freeze after exceeding linger time":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.freeze_progress > 0 # cheap gate: only players with freeze buildup
    @Condition getTotalTimeElapsed() >= eventPlayer.freeze_linger_end_time

    clearFreezeEffect()


def clearFreezeEffect():
    @Name "[mei/blaster.opy]: clearFreezeEffect()"

    eventPlayer.freeze_progress = 0


rule "[mei/blaster.opy]: OW1 Endothermic Blaster range":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventAbility == Button.ULTIMATE

    eventPlayer.blaster_damage_range = distance(attacker.getEyePosition(), victim)
    
    if eventPlayer.blaster_damage_range > OW1_MEI_ENDOTHERMIC_BLASTER_RANGE: 
        heal(victim, null, eventDamage)
        setBaseDamage(eventPlayer, MIN_DAMAGE)
    elif eventPlayer.blaster_damage_range < OW1_MEI_ENDOTHERMIC_BLASTER_RANGE:
        setBaseDamage(eventPlayer, OW1_MEI_BLASTER_DAMAGE_RATE/OW2_MEI_BLASTER_DAMAGE_RATE)
    

rule "[mei/blaster.opy]: Reset Damage when not firing primary":
    @Event eachPlayer
    @Hero mei
    @Condition not eventPlayer.isFiringPrimaryFire() and eventPlayer._base_damage_scalar == MIN_DAMAGE

    setBaseDamage(eventPlayer, OW1_MEI_BLASTER_DAMAGE_RATE/OW2_MEI_BLASTER_DAMAGE_RATE)
    wait(TICK_DURATION)
    if RULE_CONDITION: goto RULE_START