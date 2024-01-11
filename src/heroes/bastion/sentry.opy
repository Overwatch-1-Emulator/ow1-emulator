#!mainFile "../../main.opy"


rule "[bastion/sentry.opy]: Detect sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.current_configuration == Configuration.RECON # Sentry mode can only be entered from recon mode
    @Condition eventPlayer.current_configuration != Configuration.TANK # prevents incorrectly identifying tank as sentry
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.current_configuration = Configuration.SENTRY


rule "[bastion/sentry.opy]: Initialize sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.setDamageDealt(percent(OW1_BASTION_SENTRY_CONFIG_DAMAGE/OW2_BASTION_ASSAULT_CONFIG_DAMAGE))
    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)
    eventPlayer.setKnockbackReceived(0)

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)