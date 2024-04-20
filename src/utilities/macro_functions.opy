#!mainFile "../main.opy"

# Macro function for retrieving id of hero
#!define heroID(h) (getAllHeroes().index(h))

# Check if player is playing hero
#!define isHero(player, hero) ((player.getCurrentHero() == hero) or (player.getHeroOfDuplication() == hero))

# Macro function for converting decimal to percent
#!define percent(p) (100*p)

# Macro function for converting decimal to percent
#!define roundedPercent(p) (round(percent(p)))

# Macro function for computing a percent of number
#!define percentOf(p, n) ((p)/100*(n))

# Convert angle in degrees to radians
#!define toRadians(deg) ((Math.PI/180)*deg)

# Get Facing direction normalized to the XZ plane
#!define getForwardDirection(player) (worldVector(Vector.FORWARD, player, Transform.ROTATION))

# Rotates vector around the y-axis in 3D space
# See https://stackoverflow.com/q/14607640 for formula on rotating vector in 3D space
#!define rotateRelativeToYAxis(v, angle_in_degrees) (vect((v.x*cosDeg(angle_in_degrees) + v.z*sinDeg(angle_in_degrees)), (v.y), (-v.x*sinDeg(angle_in_degrees) + v.z*cosDeg(angle_in_degrees))))

#!define cancelMomentum(player) (player.applyImpulse(player.getVelocity(), -player.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION))

#!define centerMass(player) ((player.getPosition() + player.getEyePosition())/2)

#!define isCCd(player) (player.hasStatusEffect(Status.STUNNED) \
                     or isHacked(player) \
                     or player.hasStatusEffect(Status.ASLEEP) \
                     or player.hasStatusEffect(Status.FROZEN) \
                     or player.hasStatusEffect(Status.KNOCKED_DOWN))
