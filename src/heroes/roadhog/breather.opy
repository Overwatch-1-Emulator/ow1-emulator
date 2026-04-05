#!mainFile "../../main.opy"


rule "[roadhog/breather.opy]: OW1 Take a Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isMeleeing()


    eventPlayer.setDamageReceived(percent((1-OW1_ROADHOG_BREATHER_DAMAGE_REDUCTION)/(1-OW2_ROADHOG_BREATHER_DAMAGE_REDUCTION)))
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_2) # in case player releases button during breather, we still want to end it properly
    wait(OW1_ROADHOG_BREATHER_DURATION)
    wait(OW1_ROADHOG_BREATHER_RECOVERY_TIME)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ROADHOG_BREATHER_COOLDOWN)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
