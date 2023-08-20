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


#!include "ow1/heroes/bastion/recon.opy"
#!include "ow1/heroes/bastion/sentry.opy"
#!include "ow1/heroes/bastion/tank.opy"