#!mainFile "../main.opy"

# Macro function for retrieving id of hero
#!define heroID(h) getAllHeroes().index(h)

# Macro function for converting decimal to percent
#!define percent(p) (100*p)

# Macro function for converting decimal to percent
#!define roundedPercent(p) round(percent(p))

# Macro function for computing a percent of number
#!define percentOf(p, n) (p/100*n)

# Convert angle in degrees to radians
#!define toRadians(deg) ((Math.PI/180)*deg)

# Get Facing direction normalized to the XZ plane
#!define getLateralFacingDirection(player) normalize(player.getFacingDirection() * (Vector.FORWARD + Vector.LEFT))

globalvar i
