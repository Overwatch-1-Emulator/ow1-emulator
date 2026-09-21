#!mainFile "../../main.opy"

playervar machine_gun_ammo
#!defineMember machine_gun_ready repair_pvar[8]
# getTotalTimeElapsed() when the current reload finishes (timestamp instead of a chased timer)
playervar machine_gun_reload_end_time

#!defineMember machine_gun_ammo_id repair_pvar[9]

subroutine reloadMachineGun

macro hideMachineGunAmmo():
    destroyInWorldText(eventPlayer.machine_gun_ammo_id)
    eventPlayer.machine_gun_ammo_id = null


rule "[bastion/machine_gun.opy]: Activate machine gun in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.machine_gun_ready = true
    eventPlayer.machine_gun_reload_end_time = Math.INFINITY # cancel a reload started outside sentry mode

    # show machine gun ammo
    if eventPlayer.machine_gun_ammo_id == null:
        createInWorldText(
            eventPlayer,
            "{0}|{1}".format(ceil(eventPlayer.machine_gun_ammo), OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE),
            updateEveryTick(eventPlayer.getEyePosition() + \
            (100 * (3.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + \
            ((-1.3 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()),
            verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))),
            2,
            Clip.NONE,
            WorldTextReeval.VISIBILITY_POSITION_AND_STRING,
            Color.WHITE,
            SpecVisibility.DEFAULT)
        eventPlayer.machine_gun_ammo_id = getLastCreatedText()


rule "[bastion/machine_gun.opy]: Hide machine gun ammo when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    hideMachineGunAmmo()


def reloadMachineGun():
    @Name "[bastion/machine_gun.opy]: start machine gun reload timer"

    eventPlayer.machine_gun_reload_end_time = getTotalTimeElapsed() + OW1_BASTION_SENTRY_CONFIG_RELOAD_TIME


rule "[bastion/machine_gun.opy]: finish reloading machine gun":
    @Event eachPlayer
    @Hero bastion
    @Condition getTotalTimeElapsed() >= eventPlayer.machine_gun_reload_end_time

    eventPlayer.machine_gun_ammo = OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE
    eventPlayer.setAmmo(1, OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE)


rule "[bastion/machine_gun.opy]: Consume machine gun ammo when shooting":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition eventPlayer.isFiringPrimaryFire() == true

    chase(eventPlayer.machine_gun_ammo, 0, rate=OW1_BASTION_SENTRY_CONFIG_FIRE_RATE, ChaseReeval.DESTINATION_AND_RATE)
    # machine_gun_ammo is chased, so running out is watched here with waitUntil instead of
    # in a rule condition (which may not fire on OW2). Also replaces the old separate
    # "Stop machine gun ammo consumption when not shooting" rule.
    waitUntil(not (eventPlayer.current_configuration == Configuration.SENTRY and eventPlayer.isFiringPrimaryFire()) \
              or eventPlayer.machine_gun_ammo <= 0, Math.INFINITY)
    stopChasingVariable(eventPlayer.machine_gun_ammo)

    # Out of ammo: reload automatically
    if eventPlayer.machine_gun_ammo <= 0 and eventPlayer.current_configuration == Configuration.SENTRY and not eventPlayer.isReloading():
        eventPlayer.setAmmo(1, 0) # play turret reload animation
        reloadMachineGun()


rule "[bastion/machine_gun.opy]: Reload machine gun on reload key":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.current_configuration == Configuration.SENTRY
    @Condition not eventPlayer.isReloading()

    if eventPlayer.machine_gun_ammo >= OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE: return # don't reload if ammo already full
    eventPlayer.setAmmo(1, 0) # play turret reload animation
    reloadMachineGun()


rule "[bastion/machine_gun.opy]: Reload machine gun when not in sentry mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration != Configuration.SENTRY

    reloadMachineGun()


rule "[bastion/machine_gun.opy]: Allow machine gun shooting when machine gun ready":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.machine_gun_ready # gun ready to shoot
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.allowButton(Button.PRIMARY_FIRE)


rule "[bastion/machine_gun.opy]: Disallow machine gun shooting when machine gun not ready":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.machine_gun_ready # gun not ready to shoot
    @Condition eventPlayer.current_configuration == Configuration.SENTRY

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
