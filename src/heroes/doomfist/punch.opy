#!mainFile "../../main.opy"

playervar punched_victims
playervar wall_impacted_victims
playervar punch_charge_time

subroutine initRocketPunch

# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchDamage(charge_time) \
    ((OW1_DOOMFIST_ROCKET_PUNCH_IMPACT_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_IMPACT_DAMAGE_MIN) \
     / (OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) \
     * (charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) + OW1_DOOMFIST_ROCKET_PUNCH_IMPACT_DAMAGE_MIN)
# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchWallImpactDamage(charge_time) \
    ((OW1_DOOMFIST_ROCKET_PUNCH_WALL_SLAM_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_WALL_SLAM_DAMAGE_MIN) \
     / (OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) \
     * (charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) + OW1_DOOMFIST_ROCKET_PUNCH_WALL_SLAM_DAMAGE_MIN)
# Calculate punch knockback impulse speed from punch charge time
#!define getPunchKnockbackSpeed(charge_time) \
    ((OW1_DOOMFIST_PUNCH_KNOCKBACK_MAX-OW1_DOOMFIST_PUNCH_KNOCKBACK_MIN) \
     / (OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) \
     * (charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) + OW1_DOOMFIST_PUNCH_KNOCKBACK_MIN)


#!define initRocketPunch() \
    eventPlayer.punched_victims = [] \
    eventPlayer.wall_impacted_victims = []


rule "[doomfist/punch.opy]: Initialize rocket punch":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []
    eventPlayer.punch_charge_time = 0
    chase(eventPlayer.punch_charge_time, OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX, rate=1, ChaseReeval.NONE)
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), Math.INFINITY)
    stopChasingVariable(eventPlayer.punch_charge_time)
    eventPlayer.punch_charge_time = max(OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN, eventPlayer.punch_charge_time)
    
    # cooldown
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_DOOMFIST_PUNCH_COOLDOWN) # workshop bug (doesn't work)


# DO NOT switch the order of this rule with the next rule
# The order is functionally significant
rule "[doomfist/punch.opy]: Find wall impacted victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim in attacker.punched_victims
    @Condition victim not in attacker.wall_impacted_victims

    attacker.wall_impacted_victims.append(victim)
    if (len(attacker.wall_impacted_victims) == 1): # OW1 single punch victim
        damage(victim, attacker, getRocketPunchWallImpactDamage(eventPlayer.punch_charge_time)-eventDamage)
    else: # OW2 multi punch victim
        heal(victim, null, eventDamage)


# DO NOT switch the order of this rule with the previous rule
# The order is functionally significant
rule "[doomfist/punch.opy]: Find punched victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim not in attacker.punched_victims

    attacker.punched_victims.append(victim)
    if (len(attacker.punched_victims) == 1): # OW1 single punch victim
        damage(victim, attacker, getRocketPunchDamage(eventPlayer.punch_charge_time)-eventDamage)
        victim.applyImpulse(attacker.getFacingDirection(), getPunchKnockbackSpeed(eventPlayer.punch_charge_time), Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION) # Apply knockback manually
        damage(attacker, null, OW2_DOOMFIST_BEST_DEFENSE - OW1_DOOMFIST_BEST_DEFENSE)
    else: # OW2 multi punch victim
        heal(victim, null, eventDamage) # Heal back OW2 punch victims
        # Transfer shield gained from uppercut to shield gained from OW2 punch victims
        damage(attacker, null, OW2_DOOMFIST_BEST_DEFENSE - min(OW2_DOOMFIST_BEST_DEFENSE, attacker.uppercut_shields))
        attacker.uppercut_shields -= min(OW2_DOOMFIST_BEST_DEFENSE, attacker.uppercut_shields)


rule "[doomfist/punch.opy]: Remove Empowered Punch from ultimate":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.is_ultimate_locked = true
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 4.8)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.016)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(false)
    wait()
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.is_ultimate_locked = false
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    if eventPlayer.isHoldingButton(Button.ABILITY_1):
        wait() # Without wait, doom gets extra slam damage
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    if eventPlayer.isHoldingButton(Button.ABILITY_2):
        eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


rule "[doomfist/punch.opy]: Remove stun from wall impact":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim in eventPlayer.wall_impacted_victims
    
    victim.clearStatusEffect(Status.STUNNED)
