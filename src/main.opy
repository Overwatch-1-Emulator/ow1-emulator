#!include "env/env.opy"

# Useful constants
# !include "constants/ow1_constants.opy"
# !include "constants/ow2_constants.opy"

# Useful functions
# !include "utilities/macro_functions.opy"
# !include "utilities/stat_helper.opy"
# !include "utilities/custom_hp.opy"
#!include "utilities/reset.opy"
#!include "utilities/hero_switch.opy"
# !include "utilities/hero_roster.opy"
# !include "utilities/role_lock.opy"
# !include "utilities/ready.opy"
# !include "utilities/hit_detection.opy"
#!include "utilities/anti_crash.opy"

# Custom game lobby settings
#!include "lobby/lobby.opy"

# OW1 logic
# Remove damage passive
#!include "passives/damage/damage_passive.opy"
# Remove tank passive
# !include "passives/tank/ult_charge.opy"
#!include "passives/tank/knockback.opy"
# Remove support passive
#!include "passives/support/self_heal.opy"

# Include for global scoping
# !include "heroes/sombra/hack.opy"
#!include "heroes/echo/init.opy"

# Hero specific logic
# Tanks
#!include "heroes/dva/init.opy"
#!include "heroes/doomfist/init.opy"
#!include "heroes/junkerqueen/init.opy"
#!include "heroes/mauga/init.opy"
#!include "heroes/orisa/init.opy"
#!include "heroes/ramattra/init.opy"
#!include "heroes/reinhardt/init.opy"
#!include "heroes/roadhog/init.opy"
#!include "heroes/sigma/init.opy"
#!include "heroes/winston/init.opy"
#!include "heroes/wreckingball/init.opy"
#!include "heroes/zarya/init.opy"

# DPS
#!include "heroes/ashe/init.opy"
#!include "heroes/bastion/init.opy"
#!include "heroes/echo/init.opy"
#!include "heroes/genji/init.opy"
#!include "heroes/hanzo/init.opy"
#!include "heroes/junkrat/init.opy"
#!include "heroes/mccree/init.opy"
#!include "heroes/mei/init.opy"
#!include "heroes/pharah/init.opy"
#!include "heroes/reaper/init.opy"
#!include "heroes/sojourn/init.opy"
#!include "heroes/soldier/init.opy"
#!include "heroes/sombra/init.opy"
#!include "heroes/symmetra/init.opy"
#!include "heroes/torbjorn/init.opy"
#!include "heroes/tracer/init.opy"
#!include "heroes/venture/init.opy"
#!include "heroes/widowmaker/init.opy"

# Supports
#!include "heroes/ana/init.opy"
#!include "heroes/baptiste/init.opy"
#!include "heroes/brigitte/init.opy"
#!include "heroes/illari/init.opy"
#!include "heroes/kiriko/init.opy"
#!include "heroes/lifeweaver/init.opy"
#!include "heroes/lucio/init.opy"
#!include "heroes/mercy/init.opy"
#!include "heroes/moira/init.opy"
#!include "heroes/zenyatta/init.opy"

# Include debug at the end so any variable can be viewed
# !include "utilities/debug.opy"

# !include "utilities/watermark.opy"
