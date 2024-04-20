#!mainFile "../../dev_main.opy"


rule "[bastion/sentry.opy]: Initialize sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.current_configuration == Configuration.RECON # Sentry mode can only be entered from recon mode
    @Condition eventPlayer.current_configuration != Configuration.TANK # prevents incorrectly identifying tank as sentry
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.current_configuration = Configuration.SENTRY

    setBaseDamage(eventPlayer, OW1_BASTION_SENTRY_CONFIG_DAMAGE/OW2_BASTION_ASSAULT_CONFIG_DAMAGE)
    eventPlayer.setStatusEffect(null, Status.ROOTED, Math.INFINITY)
    eventPlayer.setKnockbackReceived(0)

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    eventPlayer.setMoveSpeed(0)


rule "[bastion/sentry.opy]: Extend sentry mode": # thanks to Wadetata for this wonderful piece of code that Ciach795 rewrote to OverPy: https://workshop.codes/AMSG8
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isUsingAbility1()

    do:
        wait(1, Wait.IGNORE_CONDITION)
        waitUntil(not eventPlayer.isUsingAbility1(), 4.984) # 6 second total time - 1 second - 1 tick
        waitUntil(eventPlayer.isHoldingButton(Button.ABILITY_1) or not eventPlayer.isUsingAbility1(), 1)
        if eventPlayer.isUsingAbility1() and not eventPlayer.isHoldingButton(Button.ABILITY_1):
            wait(0.016, Wait.IGNORE_CONDITION)
            eventPlayer.cancelPrimaryAction()
            eventPlayer.forceButtonPress(Button.ABILITY_1)
    while RULE_CONDITION
