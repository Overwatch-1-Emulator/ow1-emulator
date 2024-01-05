#!mainFile "main.opy"

# Useful constants
#!include "constants/env_constants.opy"
#!include "constants/ow1_constants.opy"
#!include "constants/ow2_constants.opy"

# Useful functions
#!include "utilities/custom_hp.opy"
#!include "utilities/macro_functions.opy"
#!include "utilities/reset.opy"
#!include "utilities/hero_switch.opy"
#!include "utilities/hero_roster.opy"
#!include "utilities/role_lock.opy"
#!include "utilities/ready.opy"
#!include "utilities/hit_detection.opy"
#!include "utilities/anti_crash.opy"
#!include "utilities/info.opy"

# Custom game lobby settings
#!include "lobby_settings.opy"

# OW1 logic
# Remove tank passive
#!include "passives/ult_charge.opy"
#!include "passives/tank/knockback.opy"
# Remove support passive
#!include "passives/support/self_heal.opy"

# Hero specific logic
#!include "heroes/ana/init.opy"
#!include "heroes/brigitte/init.opy"
#!include "heroes/dva/init.opy"
#!include "heroes/lucio/init.opy"
#!include "heroes/moira/init.opy"
#!include "heroes/reinhardt/init.opy"
#!include "heroes/winston/init.opy"
#!include "heroes/zarya/init.opy"
#!include "heroes/zenyatta/init.opy"

# Include debug at the end so any variable can be viewed
#!include "utilities/debug.opy"
