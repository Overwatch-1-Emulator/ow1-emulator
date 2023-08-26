#!mainFile "../../../main.opy"

playervar orisa_ammo
playervar orisa_ammo_hud

subroutine resetFusionDriver
subroutine reloadFusionDriver
subroutine refreshAmmo

subroutine createOrisaAmmoHud
subroutine destroyOrisaAmmoHud

rule "[orisa/gun.opy]: Initialize OW1 Orisa clip size":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init == true

    resetFusionDriver()
    createOrisaAmmoHud()


rule "[orisa/gun.opy]: Remove ammo hud":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    destroyOrisaAmmoHud()


rule "[orisa/gun.opy]: Decrease ammo when shooting gun":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isFiringPrimaryFire()
    
    eventPlayer.orisa_ammo -= 1
    refreshAmmo()
    eventPlayer.setPrimaryFireEnabled(false)
    wait(1/OW1_ORISA_FIRE_RATE)
    eventPlayer.setPrimaryFireEnabled(true)


rule "[orisa/gun.opy]: Reload on key press":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    
    reloadFusionDriver()


rule "[orisa/gun.opy]: Reload when out of ammo":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.orisa_ammo <= 0
    
    reloadFusionDriver()


def resetFusionDriver():
    @Name "[orisa/gun.opy]: resetFusionDriver()"

    eventPlayer.setMaxAmmo(0, OW1_ORISA_CLIP_SIZE + 1)
    eventPlayer.orisa_ammo = OW1_ORISA_CLIP_SIZE
    refreshAmmo()


def reloadFusionDriver():
    @Name "[orisa/gun.opy]: reloadFusionDriver()"

    if eventPlayer.orisa_ammo >= OW1_ORISA_CLIP_SIZE:
        return # Abort if ammo already full

    eventPlayer.setAmmo(0, 0) # Play reload animation
    wait(OW1_ORISA_RELOAD_TIME)
    resetFusionDriver()


def refreshAmmo():
    @Name "[orisa/gun.opy]: refreshAmmo()"

    eventPlayer.setAmmo(0, eventPlayer.orisa_ammo + 1)


def createOrisaAmmoHud():
    @Name "[orisa/gun.opy]: createOrisaAmmoHud()"
    
    createInWorldText(eventPlayer, 
                      "{0}".format(ceil(eventPlayer.orisa_ammo)),
                      updateEveryTick(eventPlayer.getEyePosition() + \
                      (100 * (3.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + \
                      ((-1.3 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
                      verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
                      2, 
                      Clip.NONE, 
                      WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
                      Color.WHITE, 
                      SpecVisibility.DEFAULT)
    eventPlayer.orisa_ammo_hud = getLastCreatedText()


def destroyOrisaAmmoHud():
    @Name "[orisa/gun.opy]: destroyOrisaAmmoHud()"

    destroyInWorldText(eventPlayer.orisa_ammo_hud)


rule "[orisa/gun.opy]: Slow down Orisa when shooting":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.setMoveSpeed(100-percent(OW1_ORISA_MOVEMENT_PENALTY))
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 9999)
    eventPlayer.setMoveSpeed(100)
