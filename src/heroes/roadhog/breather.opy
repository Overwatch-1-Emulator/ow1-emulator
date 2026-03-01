#!mainFile "../../main.opy"

#playervar breather_pvar
# !defineMember _is_using_breather breather_pvar[0]

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
    #@Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isMeleeing()

    # activate ability
    #eventPlayer._is_using_breather = true
    #eventPlayer.setAbility2Enabled(false)
    eventPlayer.setDamageReceived(percent((1-OW1_ROADHOG_BREATHER_DAMAGE_REDUCTION)/(1-OW2_ROADHOG_BREATHER_DAMAGE_REDUCTION))) # reduce daamge intake
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    #wait(OW1_ROADHOG_BREATHER_DURATION)
    wait(OW1_ROADHOG_BREATHER_DURATION)
    #waitUntil(eventPlayer.isFiringSecondaryFire() == false, Math.INFINITY)
    #wait(0.17)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
    #eventPlayer.setSecondaryFireEnabled(false) # disable secondary fire to prevent animation canceling, will be re-enabled after recovery time
    # eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageReceived(100) # reset damage intake
    wait(OW1_ROADHOG_BREATHER_RECOVERY_TIME)
    #wait(OW1_ROADHOG_BREATHER_COOLDOWN)

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ROADHOG_BREATHER_COOLDOWN)




    #eventPlayer._is_using_breather = false
    #wait()
    #eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8) # set cooldown to 8 seconds after using breather, same as OW1
    #wait(8)
    #eventPlayer.allowButton(Button.ABILITY_2)

    # cooldown
    #eventPlayer.setAbility2Enabled(true)
    #eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ROADHOG_BREATHER_COOLDOWN)


    # do something for testing

#rule "[roadhog/breather.opy]: Allow self healing during Breather":
#    @Event eachPlayer
#    @Hero roadhog
#    @Condition eventPlayer._is_using_breather

#    pushSelfHealing(Button.ABILITY_2)
#    waitUntil(not eventPlayer._is_using_breather, Math.INFINITY)
#    popSelfHealing(Button.ABILITY_2)

#rule "[roadhog/breather.opy]: Stunned CC with Breahter":
#    @Event eachPlayer
#    @Hero roadhog
#    @Condition eventPlayer.isUsingAbility2()
#    @Condition isCCd(eventPlayer)

#    wait(2)
#    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_ROADHOG_BREATHER_COOLDOWN_CC)
#    eventPlayer._is_using_breather = false
