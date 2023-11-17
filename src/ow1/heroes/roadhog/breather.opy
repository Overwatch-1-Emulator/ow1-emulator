#!mainFile "../../../main.opy"

# rule "[roadhog/breather.opy]: Remove healing buff after breather":
#     @Event eachPlayer
#     @Hero roadhog
#     @Condition eventPlayer.isUsingAbility2()

#     wait(OW2_ROADHOG_BREATHER_DURATION, Wait.ABORT_WHEN_FALSE)
#     eventPlayer.setHealingReceived(percent(1/(1+OW2_ROADHOG_BREATHER_HEAL_BUFF)))
#     wait(OW2_ROADHOG_BREATHER_HEAL_BUFF_DURATION)
#     eventPlayer.setHealingReceived(100)

rule "[roadhog/breather.opy]: OW1 Take a Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED)
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()

    # activate ability
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setHealingDealt(0)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(OW1_ROADHOG_BREATHER_CAST_TIME)
    eventPlayer.setHealingDealt(percent(OW1_ROADHOG_BREATHER_HEAL_TOTAL/392)) # 392 = based on trial and error
    wait(OW1_ROADHOG_BREATHER_DURATION)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    wait(OW1_ROADHOG_BREATHER_RECOVERY_TIME)

    # cooldown
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ROADHOG_BREATHER_COOLDOWN)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_ROADHOG_BREATHER_COOLDOWN)
