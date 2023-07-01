#!include "utilities.opy"
#!include "ow1_constants.opy"
#!include "ow2_constants.opy"

enum Configuration:
    RECON,
    SENTRY,
    TANK

playervar bastion_tracker
playervar bastion_tank_mode
playervar sentry_ammo
playervar bastion_self_heal_ammo
playervar bastion_repairing
playervar bastion_self_heal_ui
playervar bastion_sentry_ammo_ui
playervar bastion_sentry_ammo_bar
playervar bastion_self_heal_bar

playervar current_configuration
playervar sentry_gui_visibility
playervar heal_gui_visibility
playervar heal_resource
playervar is_tank_mode
playervar sentry_gun_ready
playervar self_repair

rule "[bastion.opy]: Initialize hero":
    @Event eachPlayer
    @Hero bastion

    eventPlayer.sentry_gui_visibility = null
    eventPlayer.heal_gui_visibility = null
    eventPlayer.heal_resource = ow1_max_heal_duration_BASTION
    eventPlayer.sentry_ammo = ow1_max_sentry_ammo_BASTION
    eventPlayer.sentry_gun_ready = true
    eventPlayer.current_configuration = Configuration.RECON

    progressBarHud(eventPlayer.sentry_gui_visibility, 
                   roundedPercent(eventPlayer.sentry_ammo/ow1_max_sentry_ammo_BASTION), 
                   "Ammo: {0}".format(ceil(eventPlayer.sentry_ammo)), 
                   HudPosition.RIGHT, 
                   0, 
                   Color.ORANGE, 
                   Color.ORANGE, 
                   ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
                   SpecVisibility.DEFAULT)

    progressBarHud(eventPlayer.heal_gui_visibility, 
                   roundedPercent(eventPlayer.heal_resource/ow1_max_heal_duration_BASTION), 
                   "Self-Repair", 
                   HudPosition.TOP, 
                   0, 
                   Color.YELLOW, 
                   Color.YELLOW, 
                   ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
                   SpecVisibility.DEFAULT)


rule "[bastion.opy]: Define recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isInAlternateForm()

    eventPlayer.current_configuration = Configuration.RECON


rule "[bastion.opy]: Define sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.current_configuration = Configuration.SENTRY


rule "[bastion.opy]: Show sentry gui when in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.sentry_gui_visibility = eventPlayer


rule "[bastion.opy]: Hide sentry gui when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    eventPlayer.sentry_gui_visibility = null


rule "[bastion.opy]: Deplete sentry ammo when shooting in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire() == true

    chase(eventPlayer.sentry_ammo, 0, rate=35, ChaseReeval.DESTINATION_AND_RATE)


rule "[bastion.opy]: Stop depleting sentry ammo when not shooting in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire() == false

    stopChasingVariable(eventPlayer.sentry_ammo)


rule "[bastion.opy]: No cooldown on reconfigure (ability 1)":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY
    @Condition eventPlayer.isUsingAbility1() == false

    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    

rule "[bastion.opy]: Prevent movement during Sentry Mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    waitUntil(eventPlayer.isOnGround(), 9999)
    eventPlayer.setMoveSpeed(0)


rule "[bastion.opy]: Allow movement outside Sentry Mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    eventPlayer.setMoveSpeed(100)


rule "[bastion.opy]: Allow turret shooting when sentry gun ready":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.sentry_gun_ready == true # gun ready to shoot

    eventPlayer.setPrimaryFireEnabled(true)


rule "[bastion.opy]: Disallow turret shooting when sentry gun not ready":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.sentry_gun_ready == false # gun ready not to shoot

    eventPlayer.setPrimaryFireEnabled(false)


rule "[bastion.opy]: Always allow shooting on recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.RECON

    eventPlayer.setPrimaryFireEnabled(true)


def reloadSentryGun():
    eventPlayer.sentry_gun_ready = false
    smallMessage(eventPlayer, "Reloading . . .")
    wait(ow1_sentry_reload_time_BASTION)
    eventPlayer.sentry_ammo = ow1_max_sentry_ammo_BASTION
    eventPlayer.sentry_gun_ready = true
    smallMessage(eventPlayer, "Done")


rule "[bastion.opy]: Reload sentry gun":
    @Event eachPlayer
    @Hero bastion
    @Condition (eventPlayer.isHoldingButton(Button.RELOAD)) or (eventPlayer.sentry_ammo <= 0)
    @Condition eventPlayer.sentry_ammo < ow1_max_sentry_ammo_BASTION

    reloadSentryGun()


rule "[bastion.opy]: Start self-repair on ability 2":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)

    wait(ow1_heal_cast_time_BASTION)
    eventPlayer.self_repair = true


rule "[bastion.opy]: Stop self-repair on ability 2 release":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.self_repair = false


rule "[bastion.opy]: Stop self-repair when no healing resource left":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.heal_resource <= 0

    eventPlayer.self_repair = false


rule "[bastion.opy]: Heal using self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == true
    @Condition eventPlayer.heal_resource > 0

    do:
        # Heal 1.44 hp every game tick (1 tick/0.016 seconds) to approximate 90 healing per second
        heal(eventPlayer, eventPlayer, 1.44)
        wait()
    while (RULE_CONDITION)


rule "[bastion.opy]: Show self-repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.heal_resource < ow1_max_heal_duration_BASTION

    eventPlayer.heal_gui_visibility = eventPlayer


rule "[bastion.opy]: Hide self-repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.heal_resource >= ow1_max_heal_duration_BASTION

    eventPlayer.heal_gui_visibility = null


rule "[bastion.opy]: Deplete heal resource on self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == true

    stopChasingVariable(eventPlayer.heal_resource)
    chase(eventPlayer.heal_resource, 0, duration=ow1_max_heal_duration_BASTION, ChaseReeval.DESTINATION_AND_DURATION)


rule "[bastion.opy]: Recharge heal resource on exiting self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == false

    stopChasingVariable(eventPlayer.heal_resource)
    chase(eventPlayer.heal_resource, ow1_max_heal_duration_BASTION, duration=ow1_heal_recharge_duration_BASTION, ChaseReeval.DESTINATION_AND_DURATION)
    if eventPlayer.heal_resource <= 0:
        wait(ow1_cooldown_ability2_BASTION)


rule "[bastion.opy]: Continuous Sentry Mode":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.bastion_tank_mode == false
    @Condition eventPlayer.isDummy() == false
    

    waitUntil(eventPlayer.isInAlternateForm() == false, ow2_assault_form_bastion_length)
    if eventPlayer.isHoldingButton(Button.ABILITY_1):
        return
    eventPlayer.cancelPrimaryAction()
    wait()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.02)
    stopChasingVariable(eventPlayer.sentry_ammo)
    wait(0.5)
    
    wait(0.7)
    if eventPlayer.isFiringPrimaryFire() == true:
        chase(eventPlayer.sentry_ammo, 300, rate=35, ChaseReeval.DESTINATION_AND_RATE)
    if RULE_CONDITION:
        goto RULE_START


rule "[bastion.opy]: Progress Bar":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.bastion_tank_mode == false
    
    wait()
    if eventPlayer.isHoldingButton(Button.ABILITY_1) == false:
        return
    wait(1)
    if eventPlayer.bastion_sentry_ammo_ui == false:
        progressBarHud(eventPlayer, 
        eventPlayer.sentry_ammo / 3, 
        "{0} Sentry Ammo Remaining: {1}".format(abilityIconString(Hero.BASTION, Button.ABILITY_1), 
        300 - floor(eventPlayer.sentry_ammo)), 
        HudPosition.TOP, 
        0, 
        Color.ORANGE, 
        Color.ORANGE, 
        ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
        SpecVisibility.DEFAULT)
        eventPlayer.bastion_sentry_ammo_bar = getLastCreatedText()
        eventPlayer.bastion_sentry_ammo_ui = true


rule "[bastion.opy]: Recon Mode":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1.5)
    if eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) >= 1:
    else:
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 1)
    stopChasingVariable(eventPlayer.sentry_ammo)
    wait(1.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.sentry_ammo = 0
    eventPlayer.sentry_gui_visibility = null
    eventPlayer.bastion_sentry_ammo_ui = false


rule "[bastion.opy]: Reload":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition (eventPlayer.isUsingAbility1() and eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.sentry_ammo >= 300) == true
    
    eventPlayer.setAmmo(1, 0)
    stopChasingVariable(eventPlayer.sentry_ammo)
    wait(0.5)
    waitUntil(eventPlayer.isReloading() == false, 1.5)
    if eventPlayer.isReloading() == true:
        eventPlayer.cancelPrimaryAction()
    eventPlayer.sentry_ammo = 0


rule "[bastion.opy]: Turret Form Movement Speed":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.bastion_tank_mode == false
    
    eventPlayer.setStatusEffect(null, Status.ROOTED, 50)
    eventPlayer.setDamageDealt(150)
    eventPlayer.setKnockbackReceived(0)
    eventPlayer.setJumpEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)


rule "[bastion.opy]: Effects Remove Sentry Mode":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true
    #If the player has CC (Knocked Down, Slept, Frozen, Rooted, Stunned)
    @Condition (eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.STUNNED)) == true
    @Condition eventPlayer.bastion_tank_mode == false
    
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


rule "[bastion.opy]: Recon Form Movement Speed":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm() == false
    
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)


rule "[bastion.opy]: Tank Mode":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.bastion_tank_mode = true
    wait(0.5)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setSecondaryFireEnabled(true)
    wait(0.05)
    eventPlayer.sentry_gui_visibility = null
    eventPlayer.bastion_sentry_ammo_ui = false
    stopChasingVariable(eventPlayer.sentry_ammo)
    eventPlayer.sentry_ammo = 0
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
    eventPlayer.bastion_tank_mode = false
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setUltCharge(0)
    eventPlayer.allowButton(Button.ABILITY_1)
    wait(0.05)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "[bastion.opy]: Tank Mode Reload":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.bastion_tank_mode == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0.5, 3)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.2)


rule "[bastion.opy]: Disallow Primary":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.bastion_tank_mode == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START

rule "[bastion.opy]: Use Self Heal":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true and eventPlayer.getHealth() < 299.5 and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false


    wait(0.5)
    #floor(eventPlayer.bastion_self_heal_ammo))
    if eventPlayer.bastion_self_heal_ui == false:
        progressBarHud(eventPlayer, eventPlayer.bastion_self_heal_ammo / 2.994, "{0} Self Healing".format(abilityIconString(Hero.BASTION, Button.ABILITY_1)), HudPosition.TOP, 0, Color.ORANGE, Color.ORANGE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)
        eventPlayer.bastion_self_heal_bar = getLastCreatedText()
        eventPlayer.bastion_self_heal_ui = true
    while eventPlayer.isHoldingButton(Button.ABILITY_2) and eventPlayer.bastion_self_heal_ammo <= 299.7 and eventPlayer.getHealth() < 299.5 and eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false:
        # Heal 1.44 hp every game tick (1 tick/0.016 seconds) to approximate 90 healing per second
        wait()
        eventPlayer.bastion_repairing = true
        heal(eventPlayer, eventPlayer, 1.44)
        eventPlayer.bastion_self_heal_ammo += 1.44


rule "[bastion.opy]: Charge Self Heal Ammo":
    @Disabled
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == false

    if eventPlayer.bastion_self_heal_ammo == 0:
        destroyProgressBarHud(eventPlayer.bastion_self_heal_bar)
        eventPlayer.bastion_self_heal_ui = false
    while eventPlayer.isHoldingButton(Button.ABILITY_2) == false and eventPlayer.bastion_self_heal_ammo > 0:
        eventPlayer.bastion_repairing = false
        wait()
        if eventPlayer.bastion_self_heal_ammo <= 0.684323:
            eventPlayer.bastion_self_heal_ammo = 0
            destroyProgressBarHud(eventPlayer.bastion_self_heal_bar)
            eventPlayer.bastion_self_heal_ui = false
        else:
            eventPlayer.bastion_self_heal_ammo -= 0.6843424
