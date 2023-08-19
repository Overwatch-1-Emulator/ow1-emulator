#!mainFile "../../../main.opy"

# Calculate OW1 meteor strike outer sphere damage from OW2 meteor strike outer sphere damage
#!define getMeteorStrikeDamage(d) \
    (OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE \
     + ((OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW1_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE) \
        / (OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MIN_DAMAGE)) \
        * (d - OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE))

rule "[meteor.opy]: Deal OW1 Meteor Strike damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage < (OW2_DOOMFIST_METEOR_STRIKE_OUTER_SPHERE_MAX_DAMAGE + OW2_DOOMFIST_METEOR_STRIKE_INNER_SPHERE_DAMAGE)/2

    damage(victim, attacker, getMeteorStrikeDamage(eventDamage) - eventDamage)
