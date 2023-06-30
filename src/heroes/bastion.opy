playervar BastionTracker
playervar BastionSentryAmmoBar
playervar BastionTankMode
playervar BastionSentryAmmo
playervar BastionSelfHealAmmo
playervar BastionReparing
playervar BastionSelfHealBar
playervar BastionSelfHealUI
playervar BastionSentryAmmoUI
#!include "ow2_constants.opy"

rule "Bastion - Technical Tracker":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BASTION
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) == false
    
    eventPlayer.BastionTracker = getLastCreatedText()
    waitUntil(eventPlayer.getCurrentHero() != Hero.BASTION or eventPlayer.hasStatusEffect(Status.HACKED) == true, 99999)
    destroyProgressBarHud(eventPlayer.BastionSentryAmmoBar)


rule "Bastion - Continuous Sentry Mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.BastionTankMode == false
    @Condition eventPlayer.isDummy() == false
    

    waitUntil(eventPlayer.isInAlternateForm() == false, ow2_assault_form_bastion_length)
    if eventPlayer.isHoldingButton(Button.ABILITY_1):
        return
    eventPlayer.cancelPrimaryAction()
    wait()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.02)
    stopChasingVariable(eventPlayer.BastionSentryAmmo)
    wait(0.5)
    
    wait(0.7)
    if eventPlayer.isFiringPrimaryFire() == true:
        chase(eventPlayer.BastionSentryAmmo, 300, rate=35, ChaseReeval.DESTINATION_AND_RATE)
    if RULE_CONDITION:
        goto RULE_START


rule "Bastion - Start Chasing Sentry Ammo":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    chase(eventPlayer.BastionSentryAmmo, 300, rate=35, ChaseReeval.DESTINATION_AND_RATE)


rule "Bastion - Stop Chasing Sentry Ammo":
    @Event eachPlayer
    @Hero bastion
    @Condition (eventPlayer.isFiringPrimaryFire() == false or eventPlayer.isUsingAbility1() == false) == true
    
    stopChasingVariable(eventPlayer.BastionSentryAmmo)


rule "Bastion - Progress Bar":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.BastionTankMode == false
    
    wait()
    if eventPlayer.isHoldingButton(Button.ABILITY_1) == false:
        return
    wait(1)
    if eventPlayer.BastionSentryAmmoUI == false:
        progressBarHud(eventPlayer, eventPlayer.BastionSentryAmmo / 3, "{0} Sentry Ammo Remaining: {1}".format(abilityIconString(Hero.BASTION, Button.ABILITY_1), 300 - floor(eventPlayer.BastionSentryAmmo)), HudPosition.TOP, 0, Color.ORANGE, Color.ORANGE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
        eventPlayer.BastionSentryAmmoBar = getLastCreatedText()
        eventPlayer.BastionSentryAmmoUI = true


rule "Bastion - Recon Mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1.5)
    if eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) >= 1:
    else:
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 1)
    stopChasingVariable(eventPlayer.BastionSentryAmmo)
    wait(1.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.BastionSentryAmmo = 0
    destroyProgressBarHud(eventPlayer.BastionSentryAmmoBar)
    eventPlayer.BastionSentryAmmoUI = false


rule "Bastion - Reload":
    @Event eachPlayer
    @Hero bastion
    @Condition (eventPlayer.isUsingAbility1() and eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.BastionSentryAmmo >= 300) == true
    
    eventPlayer.setAmmo(1, 0)
    stopChasingVariable(eventPlayer.BastionSentryAmmo)
    wait(0.5)
    waitUntil(eventPlayer.isReloading() == false, 1.5)
    if eventPlayer.isReloading() == true:
        eventPlayer.cancelPrimaryAction()
    eventPlayer.BastionSentryAmmo = 0


rule "Bastion - Turret Form Movement Speed":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.BastionTankMode == false
    
    eventPlayer.setStatusEffect(null, Status.ROOTED, 50)
    eventPlayer.setDamageDealt(150)
    eventPlayer.setKnockbackReceived(0)
    eventPlayer.setJumpEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)


rule "Bastion - Effects Remove Sentry Mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true
    #If the player has CC (Knocked Down, Slept, Frozen, Rooted, Stunned)
    @Condition (eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED)) == true
    @Condition eventPlayer.BastionTankMode == false
    
    #If the player has CC (Knocked Down, Slept, Frozen, Rooted, Stunned)
    waitUntil((eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED)) == false, 99999)
    wait()
    if eventPlayer.isUsingAbility1() == false:
        return
    if eventPlayer.hasStatusEffect(Status.HACKED) == true:
        goto lbl_0
    wait(1.6)
    lbl_0:
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.05)
    eventPlayer.stopForcingButton(Button.ABILITY_1)


rule "Bastion - Recon Form Movement Speed":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm() == false
    
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)


rule "Bastion - Tank Mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.BastionTankMode = true
    wait(0.5)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setSecondaryFireEnabled(true)
    wait(0.05)
    destroyProgressBarHud(eventPlayer.BastionSentryAmmoBar)
    eventPlayer.BastionSentryAmmoUI = false
    stopChasingVariable(eventPlayer.BastionSentryAmmo)
    eventPlayer.BastionSentryAmmo = 0
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setMoveSpeed(153.9)
    eventPlayer.setDamageDealt(180)
    eventPlayer.setProjectileSpeed(150)
    eventPlayer.setProjectileGravity(10)
    eventPlayer.disallowButton(Button.ABILITY_1)
    wait(0.05)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    waitUntil(not eventPlayer.isUsingAbility1(), 8.5)
    wait(0.05)
    eventPlayer.BastionTankMode = false
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setUltCharge(0)
    eventPlayer.allowButton(Button.ABILITY_1)
    wait(0.05)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "Bastion - Tank Mode Reload":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.BastionTankMode == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0.5, 3)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.2)


rule "Bastion - Disallow Primary":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.BastionTankMode == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START

rule "Bastion - Use Self Heal":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true and eventPlayer.getHealth() < 299.5 and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false


    wait(0.5)
    #floor(eventPlayer.BastionSelfHealAmmo))
    if eventPlayer.BastionSelfHealUI == false:
        progressBarHud(eventPlayer, eventPlayer.BastionSelfHealAmmo / 2.994, "{0} Self Healing".format(abilityIconString(Hero.BASTION, Button.ABILITY_1)), HudPosition.TOP, 0, Color.ORANGE, Color.ORANGE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
        eventPlayer.BastionSelfHealBar = getLastCreatedText()
        eventPlayer.BastionSelfHealUI = true
    while eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.BastionSelfHealAmmo <= 299.7 and eventPlayer.getHealth() < 299.5 and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false:
        # Heal 1.44 hp every game tick (1 tick/0.016 seconds) to approximate 90 healing per second
        wait()
        eventPlayer.BastionReparing = true
        heal(eventPlayer, eventPlayer, 1.44)
        eventPlayer.BastionSelfHealAmmo += 1.44


rule "Bastion - Charge Self Heal Ammo":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false

    if eventPlayer.BastionSelfHealAmmo == 0:
        destroyProgressBarHud(eventPlayer.BastionSelfHealBar)
        eventPlayer.BastionSelfHealUI = false
    while eventPlayer.isHoldingButton(Button.ABILITY_2) == false and eventPlayer.BastionSelfHealAmmo > 0:
        eventPlayer.BastionReparing = false
        wait()
        if eventPlayer.BastionSelfHealAmmo <= 0.684323:
            eventPlayer.BastionSelfHealAmmo = 0
            destroyProgressBarHud(eventPlayer.BastionSelfHealBar)
            eventPlayer.BastionSelfHealUI = false
        else:
            eventPlayer.BastionSelfHealAmmo -= 0.6843424






 
    
