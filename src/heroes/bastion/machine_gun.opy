#!mainFile "../../main.opy"

playervar machine_gun_ammo
playervar machine_gun_ready
playervar machine_gun_reload_timer

playervar machine_gun_ammo_id

subroutine startMachineGunReload

subroutine showMachineGunAmmo
subroutine hideMachineGunAmmo


rule "[bastion/machine_gun.opy]: Activate machine gun in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.machine_gun_ready = true
    stopChasingVariable(eventPlayer.machine_gun_reload_timer)


def showMachineGunAmmo():
    @Name "[bastion/machine_gun.opy]: showMachineGunAmmo()"

    if eventPlayer.machine_gun_ammo_id == null:
        createInWorldText(eventPlayer, 
                        "{0}".format(ceil(eventPlayer.machine_gun_ammo)),
                        updateEveryTick(eventPlayer.getEyePosition() + \
                        (100 * (3.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + \
                        ((-1.3 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
                        verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
                        2, 
                        Clip.NONE, 
                        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
                        Color.WHITE, 
                        SpecVisibility.DEFAULT)
        eventPlayer.machine_gun_ammo_id = getLastCreatedText()


def hideMachineGunAmmo():
    @Name "[bastion/machine_gun.opy]: hideMachineGunAmmo()"

    destroyInWorldText(eventPlayer.machine_gun_ammo_id)
    eventPlayer.machine_gun_ammo_id = null


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

    showMachineGunAmmo()


rule "[bastion/machine_gun.opy]: Hide machine gun gui when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    hideMachineGunAmmo()


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
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    startMachineGunReload()

    
rule "[bastion/machine_gun.opy]: Reload machine gun if out of ammo":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.machine_gun_ammo <= 0
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

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
    @Condition eventPlayer.machine_gun_ready == false # gun not ready to shoot
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)