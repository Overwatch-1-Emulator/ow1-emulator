#!mainFile "../../dev_main.opy"

enum Configuration:
    RECON,
    SENTRY,
    TANK

playervar current_configuration

#!include "heroes/bastion/recon.opy"
#!include "heroes/bastion/sentry.opy"
#!include "heroes/bastion/tank.opy"