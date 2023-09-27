#!mainFile "../../../main.opy"

playervar machine_gun_ammo
playervar machine_gun_ready
playervar machine_gun_reload_timer

playervar machine_gun_gui

subroutine startMachineGunReload

subroutine createMachineGunGUI
subroutine destroyMachineGunGUI


rule "[bastion/machine_gun.opy]: Activate machine gun in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.machine_gun_ready = true
    stopChasingVariable(eventPlayer.machine_gun_reload_timer)


def createMachineGunGUI():
    @Name "[bastion/machine_gun.opy]: createMachineGunGUI()"

    progressBarHud(eventPlayer, 
                   roundedPercent(eventPlayer.machine_gun_ammo/OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE), 
                   "Ammo: {0}".format(ceil(eventPlayer.machine_gun_ammo)), 
                   HudPosition.TOP, 
                   0, 
                   Color.ORANGE, 
                   Color.ORANGE, 
                   ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
                   SpecVisibility.DEFAULT)
    eventPlayer.machine_gun_gui = getLastCreatedText()


def destroyMachineGunGUI():
    @Name "[bastion/machine_gun.opy]: destroyMachineGunGUI()"

    destroyProgressBarHud(eventPlayer.machine_gun_gui)


def startMachineGunReload():
    @Name "[bastion/machine_gun.opy]: start machine gun reload timer"
    if eventPlayer.machine_gun_ammo >= OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE:
        return # do nothing if ammo already full
    if eventPlayer.current_configuration == Configuration.SENTRY:
        smallMessage(eventPlayer, "Reloading . . .")
    eventPlayer.machine_gun_ready = false
    eventPlayer.machine_gun_reload_timer = OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME
    chase(eventPlayer.machine_gun_reload_timer, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "[bastion/machine_gun.opy]: finish reloading machine gun":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.machine_gun_reload_timer <= 0

    eventPlayer.machine_gun_ammo = OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE
    eventPlayer.machine_gun_ready = true
    if eventPlayer.current_configuration == Configuration.SENTRY:
        smallMessage(eventPlayer, "Done")


rule "[bastion/machine_gun.opy]: Show machine gun gui when in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    createMachineGunGUI()


rule "[bastion/machine_gun.opy]: Hide machine gun gui when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    destroyMachineGunGUI()


rule "[bastion/machine_gun.opy]: Consume machine gun ammo when shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire() == true

    chase(eventPlayer.machine_gun_ammo, 0, rate=OW1_BASTION_SENTRY_CONFIG_FIRE_RATE, ChaseReeval.DESTINATION_AND_RATE)


rule "[bastion/machine_gun.opy]: Stop machine gun ammo consumption when not shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition not (eventPlayer.current_configuration == Configuration.SENTRY and eventPlayer.isFiringPrimaryFire())

    stopChasingVariable(eventPlayer.machine_gun_ammo)


rule "[bastion/machine_gun.opy]: Reload machine gun on reload key":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    startMachineGunReload()

    
rule "[bastion/machine_gun.opy]: Reload machine gun if out of ammo":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.machine_gun_ammo <= 0

    startMachineGunReload()


rule "[bastion/machine_gun.opy]: Reload machine gun when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    startMachineGunReload()


rule "[bastion/machine_gun.opy]: Allow machine gun shooting when machine gun ready":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.machine_gun_ready == true # gun ready to shoot

    eventPlayer.allowButton(Button.PRIMARY_FIRE)


rule "[bastion/machine_gun.opy]: Disallow machine gun shooting when machine gun not ready":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.machine_gun_ready == false # gun not ready to shoot

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)