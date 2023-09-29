#!mainFile "main.opy"
#!obfuscate noConstantObfuscation

# Useful constants
#!include "constants/ow1_constants.opy"
#!include "constants/ow2_constants.opy"

# Useful functions
#!include "utilities/custom_health_handler.opy"
#!include "utilities/macro_functions.opy"
#!include "utilities/reset.opy"
#!include "utilities/hero_switch.opy"
#!include "utilities/hero_roster.opy"
#!include "utilities/role_lock.opy"
#!include "utilities/ready.opy"
#!include "utilities/hit_detection.opy"

# Custom game lobby settings
#!include "lobby_settings.opy"
# OW1 logic
#!include "ow1/ow1.opy"

# Include debug at the end so any variable can be viewed
#!include "utilities/debug.opy"
