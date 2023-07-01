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
playervar self_repair_time_left
playervar is_tank_mode
playervar sentry_gun_ready
playervar self_repair

rule "[bastion.opy]: Initialize hero":
    @Event eachPlayer
    @Hero bastion

    # Initialize Abilities
    eventPlayer.setSecondaryFireEnabled(false)

    # Initialize Variables
    eventPlayer.sentry_gui_visibility = null
    eventPlayer.heal_gui_visibility = null
    eventPlayer.self_repair_time_left = ow1_max_self_repair_duration_BASTION
    eventPlayer.sentry_ammo = ow1_max_sentry_ammo_BASTION
    eventPlayer.sentry_gun_ready = true
    eventPlayer.current_configuration = Configuration.RECON

    # Initialize GUI
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
                   roundedPercent(eventPlayer.self_repair_time_left/ow1_max_self_repair_duration_BASTION), 
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
    @Condition not eventPlayer.isInAlternateForm() # built in workshop function for detecting default hero form

    eventPlayer.current_configuration = Configuration.RECON


rule "[bastion.opy]: Define sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.current_configuration == Configuration.RECON # Sentry mode can only be entered from recon mode
    @Condition eventPlayer.current_configuration != Configuration.TANK # prevents incorrectly identifying sentry as tank mode
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.current_configuration = Configuration.SENTRY


rule "[bastion.opy]: Define tank mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.current_configuration = Configuration.TANK


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


rule "[bastion.opy]: Allow machine gun shooting when sentry gun ready":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.sentry_gun_ready == true # gun ready to shoot

    eventPlayer.setPrimaryFireEnabled(true)


rule "[bastion.opy]: Disallow machine gun shooting when sentry gun not ready":
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


def selfRepair():
    wait(ow1_self_repair_cast_time_BASTION)
    while eventPlayer.self_repair == true: # Approximate 90 healing over time using discrete healing at high frequency
        heal(eventPlayer, eventPlayer, ow1_bastion_self_repair_heal_increment) 
        wait(ow1_bastion_self_repair_heal_increment/ow1_bastion_self_repair_healing_rate)


rule "[bastion.opy]: Activate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == true

    selfRepair()


rule "[bastion.opy]: Start self-repair on ability 2":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getHealth() < ow1_health_normal_BASTION + ow1_health_armor_BASTION
    
    eventPlayer.self_repair = true


rule "[bastion.opy]: Stop self-repair on ability 2 release":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isHoldingButton(Button.ABILITY_2)

    eventPlayer.self_repair = false


rule "[bastion.opy]: Stop self-repair when no healing resource left":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left <= 0

    eventPlayer.self_repair = false


rule "[bastion.opy]: Stop self-repair when full hp":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.getHealth() >= ow1_health_normal_BASTION + ow1_health_armor_BASTION

    eventPlayer.self_repair = false


rule "[bastion.opy]: Show self-repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left < ow1_max_self_repair_duration_BASTION

    eventPlayer.heal_gui_visibility = eventPlayer


rule "[bastion.opy]: Hide self-repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left >= ow1_max_self_repair_duration_BASTION

    eventPlayer.heal_gui_visibility = null


rule "[bastion.opy]: Deplete heal resource on self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == true

    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop any ongoing resource modification
    wait(ow1_self_repair_cast_time_BASTION)
    chase(eventPlayer.self_repair_time_left, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE) # Start depleting


rule "[bastion.opy]: Recharge heal resource when not self-repairing":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == false

    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop any ongoing resource modification
    wait(ow1_self_repair_cooldown_time_BASTION) # Wait 1 second cooldown before recharging heal resource
    chase(eventPlayer.self_repair_time_left, ow1_max_self_repair_duration_BASTION, rate=ow1_max_self_repair_duration_BASTION/ow1_self_repair_recharge_duration_BASTION, ChaseReeval.DESTINATION_AND_RATE) # Start recharging


def transformInToTank():
    @Name "[bastion.opy]: Transform into tank"

    wait(min(ow1_bastion_tank_mode_cast_time, ow2_bastion_artillery_mode_cast_time))
    eventPlayer.cancelPrimaryAction() # interrupt ultimate animation right before it completes

    eventPlayer.setPrimaryFireEnabled(false) # disable machine gun
    eventPlayer.setSecondaryFireEnabled(true) # enable tank shells (geneade launcher)

    eventPlayer.setMoveSpeed(153.9) # move faster in tank mode
    eventPlayer.setDamageDealt(180) # deal more damage in tank mode
    eventPlayer.setProjectileSpeed(150) # increase grenade travel speed (to mimic tank shells)
    # eventPlayer.setProjectileGravity(10) # decrease gravity (to mimic straighter tank projectile)

    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to turret mode
    eventPlayer.disallowButton(Button.ABILITY_1) # Disable reconfiguring out of turret mode


def transformOutOfTank():
    @Name "[bastion.opy]: Transform out of tank"

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(false)

    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    # eventPlayer.setUltCharge(0)

    eventPlayer.allowButton(Button.ABILITY_1)
    if eventPlayer.isUsingAbility1():
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to recon mode


rule "[bastion.opy]: Enter tank mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.TANK
    
    transformInToTank()
    waitUntil(not eventPlayer.isUsingAbility1(), ow1_bastion_tank_mode_duration)
    transformOutOfTank()


rule "[bastion.opy]: Shoot tank shells":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.TANK
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ow1_bastion_tank_shell_reload_time) # Reload tank shell
