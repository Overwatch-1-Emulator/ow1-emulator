#!mainFile "../../main.opy"

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


rule "[doomfist/meteor.opy]: Remove Meteor Strike slow effect":
    # For some reason, playerDealtDamage activates the rule for only the first ulted victim
    # therefore, we activate the rule from the victim's perspective
    @Event playerTookDamage
    @Condition eventAbility == Button.ULTIMATE
    @Condition attacker.getCurrentHero() == Hero.DOOMFIST

    victim.setMoveSpeed(percent(1/OW2_DOOMFIST_METEOR_STRIKE_SLOW))
    wait(3)
    victim.setMoveSpeed(100)
