#!mainFile "../../dev_main.opy"

enum Configuration:
    RECON,
    SENTRY,
    TANK

playervar current_configuration

#!include "recon.opy"
#!include "sentry.opy"
#!include "tank.opy"