#!mainFile "../../../main.opy"

enum Configuration:
    RECON,
    SENTRY,
    TANK

playervar current_configuration


rule "[bastion/configuration.opy]: No cooldown on reconfigure (ability 1)":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == false

    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


#!include "heroes/bastion/recon.opy"
#!include "heroes/bastion/sentry.opy"
#!include "heroes/bastion/tank.opy"