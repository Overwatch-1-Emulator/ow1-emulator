#!mainFile "../../../main.opy"

playervar orisa_ammo
playervar reloading_

subroutine resetFusionDriver
subroutine reloadFusionDriver
subroutine refreshAmmo


rule "[orisa/ammo.opy]: Initialize OW1 Orisa clip size":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init == true

    resetFusionDriver()


rule "[orisa/ammo.opy]: Decrease ammo when shooting gun":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isFiringPrimaryFire()
    
    eventPlayer.orisa_ammo -= 1
    refreshAmmo()
    eventPlayer.setPrimaryFireEnabled(false)
    wait(1/OW1_ORISA_FIRE_RATE)
    eventPlayer.setPrimaryFireEnabled(true)


rule "[orisa/ammo.opy]: Reload on key press":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    
    reloadFusionDriver()


rule "[orisa/ammo.opy]: Reload when out of ammo":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.orisa_ammo <= 0
    
    reloadFusionDriver()


def resetFusionDriver():
    @Name "[orisa/ammo.opy]: resetFusionDriver()"

    eventPlayer.setMaxAmmo(0, OW1_ORISA_CLIP_SIZE + 1)
    eventPlayer.orisa_ammo = OW1_ORISA_CLIP_SIZE
    refreshAmmo()


def reloadFusionDriver():
    @Name "[orisa/ammo.opy]: reloadFusionDriver()"

    if eventPlayer.orisa_ammo >= OW1_ORISA_CLIP_SIZE:
        return # Abort if ammo already full

    eventPlayer.setAmmo(0, 0) # Play reload animation
    wait(OW1_ORISA_RELOAD_TIME)
    resetFusionDriver()


def refreshAmmo():
    @Name "[orisa/ammo.opy]: refreshAmmo()"

    eventPlayer.setAmmo(0, eventPlayer.orisa_ammo + 1)