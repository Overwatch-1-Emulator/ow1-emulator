#!mainFile "../../main.opy"

playervar meteor_strike_slow_time

# Calculate OW1 meteor strike outer sphere damage from OW2 meteor strike outer sphere damage
#!define getMeteorStrikeDamage(d) \
    (OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE \
     + ((OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE) \
        / (OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE)) \
        * (d - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE))


rule "[doomfist/meteor.opy]: Deal OW1 Meteor Strike damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE
    # Only activate this rule when damage is dealt by inner ring (/2 accounts for damage reduction from armor, nanoboost, etc)
    @Condition eventDamage < (OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE + OW2_DOOMFIST_METEOR_STRIKE_INNER_SPHERE_DAMAGE)/2

    damage(victim, attacker, getMeteorStrikeDamage(eventDamage) - eventDamage)


rule "[doomfist/meteor.opy]: Compensate Meteor Strike slow effect":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE

    victim.setMoveSpeed(percent(1/OW2_DOOMFIST_METEOR_STRIKE_SLOW))
    victim.meteor_strike_slow_time = OW2_DOOMFIST_METEOR_STRIKE_SLOW_DURATION
    chase(victim.meteor_strike_slow_time, 0, rate=1, ChaseReeval.NONE)


rule "[doomfist/meteor.opy]: Reset Meteor Strike slow effect compensation":
    @Event eachPlayer
    @Condition eventPlayer.meteor_strike_slow_time <= 0

    stopChasingVariable(eventPlayer.meteor_strike_slow_time)
    eventPlayer.setMoveSpeed(100)


rule "[doomfist/meteor.opy]: OW1 Meteor Strike knockback":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE

    victim.setGravity(50) 
    victim.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Boop slammed victims up
    victim.applyImpulse(directionTowards(attacker, victim), 
                        20/max(distance(attacker, victim), OW1_DOOMFIST_METEOR_STRIKE_INNER_SPHERE_RADIUS), # inverse square curve passing through (2, 10)
                        Relativity.TO_WORLD, 
                        Impulse.CANCEL_CONTRARY_MOTION_XYZ) # Push/Pull slammed victims; multiply pull magnitude by 1.5 to counteract air resistance
    victim.setGravity(100)


rule "[doomfist/meteor.opy]: Remove Meteor Strike healing":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setHealingDealt(0)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setHealingDealt(100)
