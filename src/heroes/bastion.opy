#!include "utilities.opy"
#!include "ow1_constants.opy"
#!include "ow2_constants.opy"

enum Configuration:
    RECON,
    SENTRY,
    TANK

playervar current_configuration
playervar sentry_gui_visibility
playervar heal_gui_visibility
playervar self_repair_time_left
playervar sentry_gun_ready
playervar machine_gun_ammo
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
    eventPlayer.machine_gun_ammo = ow1_max_sentry_ammo_BASTION
    eventPlayer.sentry_gun_ready = true
    eventPlayer.current_configuration = Configuration.RECON

    # Initialize GUI
    progressBarHud(eventPlayer.sentry_gui_visibility, 
                   roundedPercent(eventPlayer.machine_gun_ammo/ow1_max_sentry_ammo_BASTION), 
                   "Ammo: {0}".format(ceil(eventPlayer.machine_gun_ammo)), 
                   HudPosition.TOP, 
                   0, 
                   Color.ORANGE, 
                   Color.ORANGE, 
                   ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
                   SpecVisibility.DEFAULT)

    progressBarHud(eventPlayer.heal_gui_visibility, 
                   roundedPercent(eventPlayer.self_repair_time_left/ow1_max_self_repair_duration_BASTION), 
                   "Self-Repair", 
                   HudPosition.LEFT, 
                   1, 
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
    @Condition eventPlayer.current_configuration != Configuration.TANK # prevents incorrectly identifying tank as sentry
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


rule "[bastion.opy]: Update machine gun ammo when shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire() == true

    chase(eventPlayer.machine_gun_ammo, 0, rate=ow1_bastion_machine_gun_fire_rate, ChaseReeval.DESTINATION_AND_RATE)


rule "[bastion.opy]: Update machine gun ammo when not shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire() == false

    stopChasingVariable(eventPlayer.machine_gun_ammo)


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

    eventPlayer.setStatusEffect(null, Status.ROOTED, 9999)


rule "[bastion.opy]: Allow movement outside Sentry Mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    eventPlayer.clearStatusEffect(Status.ROOTED)


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

rule "[bastion.opy]: Set stats for recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.RECON

    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)


rule "[bastion.opy]: Set stats for sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.setDamageDealt(percent(OW1_BASTION_MACHINE_GUN_DAMAGE/OW2_BASTION_MACHINE_GUN_DAMAGE))


rule "[bastion.opy]: Set stats for tank mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.TANK

    eventPlayer.setMoveSpeed(percent(OW1_BASTION_TANK_MOVE_SPEED)) # move faster in tank mode
    eventPlayer.setDamageDealt(percent(OW1_BASTION_TANK_DAMAGE/OW2_BASTION_GRENADE_DAMAGE)) # deal more damage in tank mode
    eventPlayer.setProjectileSpeed(percent(OW1_BASTION_TANK_PROJECTILE_SPEED/OW2_BASTION_GRENADE_PROJECTILE_SPEED)) # increase grenade travel speed (to mimic tank shells)


def reloadMachineGun():
    @Name "[bastion.opy]: Reload machine gun"
    eventPlayer.sentry_gun_ready = false
    smallMessage(eventPlayer, "Reloading . . .")
    wait(ow1_sentry_reload_time_BASTION)
    eventPlayer.machine_gun_ammo = ow1_max_sentry_ammo_BASTION
    eventPlayer.sentry_gun_ready = true
    smallMessage(eventPlayer, "Done")


rule "[bastion.opy]: Reload sentry gun":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition (eventPlayer.isHoldingButton(Button.RELOAD)) or (eventPlayer.machine_gun_ammo <= 0)
    @Condition eventPlayer.machine_gun_ammo < ow1_max_sentry_ammo_BASTION

    reloadMachineGun()


def selfRepair():
    @Name "[bastion.opy]: Execute self-repair ability"
    wait(ow1_self_repair_cast_time_BASTION)
    while eventPlayer.self_repair == true: # Approximate 90 healing over time using discrete healing at high frequency
        heal(eventPlayer, eventPlayer, ow1_bastion_self_repair_heal_increment) 
        wait(ow1_bastion_self_repair_heal_increment/ow1_bastion_self_repair_healing_rate)


rule "[bastion.opy]: Activate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == true

    selfRepair()


rule "[bastion.opy]: Start self-repair on ability 2 or secondary fire":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    
    eventPlayer.self_repair = true


rule "[bastion.opy]: Stop self-repair on ability 2 release":
    @Event eachPlayer
    @Hero bastion
    @Condition not (eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)) or eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.self_repair = false


rule "[bastion.opy]: Stop self-repair when no healing resource left":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left <= 0

    eventPlayer.self_repair = false


rule "[bastion.opy]: Stop self-repair when full hp":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.getHealth() >= eventPlayer.getMaxHealth()

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
    waitUntil(not eventPlayer.self_repair, ow1_self_repair_cast_time_BASTION) # wait self-repair animation casttime
    if not eventPlayer.self_repair: # player interrupted self-repair
        return
    chase(eventPlayer.self_repair_time_left, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE) # Start depleting


rule "[bastion.opy]: Recharge heal resource when not self-repairing":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair == false

    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop any ongoing resource modification
    waitUntil(eventPlayer.self_repair, ow1_self_repair_cooldown_time_BASTION) # Wait 1 second cooldown before recharging heal resource
    if eventPlayer.self_repair:  # player interrupted self-repair
        return
    chase(eventPlayer.self_repair_time_left, ow1_max_self_repair_duration_BASTION, rate=ow1_max_self_repair_duration_BASTION/ow1_self_repair_recharge_duration_BASTION, ChaseReeval.DESTINATION_AND_RATE) # Start recharging


def transformInToTank():
    @Name "[bastion.opy]: Transform into tank"

    wait(min(ow1_bastion_tank_mode_cast_time, ow2_bastion_artillery_mode_cast_time))
    eventPlayer.cancelPrimaryAction() # interrupt ultimate animation right before it completes
    eventPlayer.setPrimaryFireEnabled(false) # disable machine gun
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.forceButtonPress(Button.ABILITY_1) # Go to turret mode
    eventPlayer.disallowButton(Button.ABILITY_1) # Disable reconfiguring out of turret mode


def transformOutOfTank():
    @Name "[bastion.opy]: Transform out of tank"

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(false)
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


rule "[bastion.opy]: Fire tank shells":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.TANK
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(false)

rule "[bastion.opy]: Reload tank shells":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.TANK
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ow1_bastion_tank_shell_reload_time) # modify cooldown for tank shell
    wait(ow1_bastion_tank_shell_reload_time) # Wait tank shell reload time
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0) # Set tank shell as available
