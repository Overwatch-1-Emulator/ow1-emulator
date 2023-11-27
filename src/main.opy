#!mainFile "main.opy"

rule "[main.opy] Disable Inspector for performance": disableInspector()

# Useful constants
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
#!include "ow1/passives/ult_charge.opy"
#!include "ow1/passives/tank/knockback.opy"
# Remove support passive
#!include "ow1/passives/support/self_heal.opy"

# Hero specific logic
#!include "ow1/heroes/ana/init.opy"
#!include "ow1/heroes/ashe/init.opy"
#!include "ow1/heroes/baptiste/init.opy"
#!include "ow1/heroes/bastion/init.opy"
#!include "ow1/heroes/brigitte/init.opy"
#!include "ow1/heroes/doomfist/init.opy"
#!include "ow1/heroes/dva/init.opy"
#!include "ow1/heroes/echo/init.opy"
#!include "ow1/heroes/genji/init.opy"
#!include "ow1/heroes/hanzo/init.opy"
#!include "ow1/heroes/illari/init.opy"
#!include "ow1/heroes/junkerqueen/init.opy"
#!include "ow1/heroes/junkrat/init.opy"
#!include "ow1/heroes/kiriko/init.opy"
#!include "ow1/heroes/lifeweaver/init.opy"
#!include "ow1/heroes/lucio/init.opy"
#!include "ow1/heroes/mccree/init.opy"
#!include "ow1/heroes/mei/init.opy"
#!include "ow1/heroes/mercy/init.opy"
#!include "ow1/heroes/moira/init.opy"
#!include "ow1/heroes/orisa/init.opy"
#!include "ow1/heroes/pharah/init.opy"
#!include "ow1/heroes/ramattra/init.opy"
#!include "ow1/heroes/reaper/init.opy"
#!include "ow1/heroes/reinhardt/init.opy"
#!include "ow1/heroes/roadhog/init.opy"
#!include "ow1/heroes/sigma/init.opy"
#!include "ow1/heroes/sojourn/init.opy"
#!include "ow1/heroes/soldier/init.opy"
#!include "ow1/heroes/sombra/init.opy"
#!include "ow1/heroes/symmetra/init.opy"
#!include "ow1/heroes/torbjorn/init.opy"
#!include "ow1/heroes/tracer/init.opy"
#!include "ow1/heroes/widowmaker/init.opy"
#!include "ow1/heroes/winston/init.opy"
#!include "ow1/heroes/wreckingball/init.opy"
#!include "ow1/heroes/zarya/init.opy"
#!include "ow1/heroes/zenyatta/init.opy"

# Include debug at the end so any variable can be viewed
#!include "utilities/debug.opy"
