#!mainFile "../../main.opy"

playervar meteor_slow_end_time # getTotalTimeElapsed() when OW2 meteor slow ends (0 = not slowed)

# Calculate OW1 meteor strike outer ring damage from OW2 meteor strike outer ring damage
macro getMeteorStrikeDamage(d):
    (OW1_DOOMFIST_METEOR_STRIKE_OUTER_RING_MAX_DAMAGE
     + ((OW1_DOOMFIST_METEOR_STRIKE_OUTER_RING_MAX_DAMAGE - OW1_DOOMFIST_METEOR_STRIKE_OUTER_RING_MIN_DAMAGE)
        / (OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE))
        * (d - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE))


rule "[doomfist/meteor.opy]: Deal OW1 Meteor Strike damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE
    # Only activate this rule when damage is dealt by inner ring (/2 accounts for damage reduction from armor, nanoboost, etc)
    @Condition eventDamage / eventPlayer._base_damage_scalar < (OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE + OW2_DOOMFIST_METEOR_STRIKE_INNER_SPHERE_DAMAGE) / 2

    damage(victim, attacker, (getMeteorStrikeDamage(eventDamage/eventPlayer._base_damage_scalar) - eventDamage/eventPlayer._base_damage_scalar) / eventPlayer._base_damage_scalar)
    

rule "[doomfist/meteor.opy]: Compensate Meteor Strike slow effect":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE

    setMoveModifier(victim, MoveMod.METEOR, 1/OW2_DOOMFIST_METEOR_STRIKE_SLOW)
    victim.meteor_slow_end_time = getTotalTimeElapsed() + OW2_DOOMFIST_METEOR_STRIKE_SLOW_DURATION


rule "[doomfist/meteor.opy]: Reset Meteor Strike slow effect compensation":
    @Event eachPlayer
    @Condition eventPlayer.meteor_slow_end_time != 0 # cheap gate: only players currently compensated
    @Condition getTotalTimeElapsed() >= eventPlayer.meteor_slow_end_time

    eventPlayer.meteor_slow_end_time = 0
    clearMoveModifier(eventPlayer, MoveMod.METEOR)


rule "[doomfist/meteor.opy]: OW1 Meteor Strike knockback":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE

    victim.setGravity(50)
    # Boop slammed victims up
    victim.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    # Boop slammed victims away from meteor strike
    victim.applyImpulse(directionTowards(attacker, victim),
                        20/max(distance(attacker, victim), OW1_DOOMFIST_METEOR_STRIKE_INNER_RING_RADIUS), # inverse square curve passing through (2, 10)
                        Relativity.TO_WORLD,
                        Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    victim.setGravity(100)


rule "[doomfist/meteor.opy]: Remove Meteor Strike healing":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setHealingDealt(0)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setHealingDealt(100)
