#!mainFile "../../../main.opy"

playervar punched_victims
playervar wall_impacted_victims
playervar punch_charge_time

# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchDamage(charge_time) \
    ((OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MIN) \
     / (OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) \
     * (charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX) + OW1_DOOMFIST_ROCKET_PUNCH_DAMAGE_MAX)
# Calculate OW1 rocket punch damage given charge time
# Assume damage scales linearly with charge time, then use the line from 2 points formula (y-y1) = (y2-y1)/(x2-x1)*(x-x1)
#!define getRocketPunchWallImpactDamage(charge_time) \
    ((OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX-OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MIN) \
     / (OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MIN) \
     * (charge_time-OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX) + OW1_DOOMFIST_ROCKET_PUNCH_WALL_IMPACT_DAMAGE_MAX)


rule "[doomfist/punch.opy]: Initialize rocket punch ability":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.call_init == true

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []


rule "[doomfist/punch.opy]: Initialize rocket punch":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []
    eventPlayer.punch_charge_time = 0
    chase(eventPlayer.punch_charge_time, OW1_DOOMFIST_ROCKET_PUNCH_CHARGE_TIME_MAX, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == false, Math.INFINITY)
    stopChasingVariable(eventPlayer.punch_charge_time)


# DO NOT switch the order of this rule with the next rule
# The order is functionally significant
rule "[doomfist/punch.opy]: Find wall impacted victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim in attacker.punched_victims
    @Condition victim not in attacker.wall_impacted_victims

    damage(victim, attacker, getRocketPunchWallImpactDamage(eventPlayer.punch_charge_time)-eventDamage)
    attacker.wall_impacted_victims.append(victim)


# DO NOT switch the order of this rule with the previous rule
# The order is functionally significant
rule "[doomfist/punch.opy]: Find punched victims":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim not in attacker.punched_victims

    damage(victim, attacker, getRocketPunchDamage(eventPlayer.punch_charge_time)-eventDamage)
    attacker.punched_victims.append(victim)


rule "[doomfist/punch.opy]: Remove Empowered Punch from ultimate":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true
    
    # eventPlayer.disallowButton(Button.ABILITY_1)
    # eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 4.8)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setStatusEffect(null, Status.STUNNED, 0.016)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setSecondaryFireEnabled(false)
    wait()
    eventPlayer.setSecondaryFireEnabled(true)
    # eventPlayer.allowButton(Button.ABILITY_1)
    # eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)


rule "[doomfist/punch.opy]: Remove stun from wall impact":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim in eventPlayer.wall_impacted_victims
    
    victim.clearStatusEffect(Status.STUNNED)
