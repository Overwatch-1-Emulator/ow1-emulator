#!mainFile "../../../main.opy"

playervar orisa_ammo
playervar orisa_ammo_hud
playervar is_orisa_reloading

subroutine resetFusionDriver
subroutine reloadFusionDriver
subroutine refreshAmmo

subroutine showOrisaAmmoHud
subroutine hideOrisaAmmoHud

#!define refreshAmmo() eventPlayer.setAmmo(0, eventPlayer.orisa_ammo + 1)


rule "[orisa/gun.opy]: Decrease ammo when shooting gun":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isFiringPrimaryFire()
    
    eventPlayer.orisa_ammo -= 1
    refreshAmmo()
    wait(1/OW1_ORISA_FIRE_RATE)


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


def reloadFusionDriver():
    @Name "[orisa/gun.opy]: reloadFusionDriver()"

    if eventPlayer.orisa_ammo >= OW1_ORISA_CLIP_SIZE: return # Abort if ammo already full

    eventPlayer.setAmmo(0, 0) # Play reload animation
    eventPlayer.is_orisa_reloading = true
    wait(OW1_ORISA_RELOAD_TIME)
    eventPlayer.is_orisa_reloading = false
    resetFusionDriver()


def resetFusionDriver():
    @Name "[orisa/gun.opy]: resetFusionDriver()"

    eventPlayer.setMaxAmmo(0, OW1_ORISA_CLIP_SIZE + 1)
    eventPlayer.orisa_ammo = OW1_ORISA_CLIP_SIZE
    refreshAmmo()


def showOrisaAmmoHud():
    @Name "[orisa/gun.opy]: showOrisaAmmoHud()"
    
    if eventPlayer.orisa_ammo_hud == null:
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


def hideOrisaAmmoHud():
    @Name "[orisa/gun.opy]: hideOrisaAmmoHud()"

    destroyInWorldText(eventPlayer.orisa_ammo_hud)
    eventPlayer.orisa_ammo_hud = null


rule "[orisa/gun.opy]: Slow down Orisa when shooting":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    @Condition not eventPlayer.is_orisa_reloading

    eventPlayer.setMoveSpeed(100-percent(OW1_ORISA_MOVEMENT_PENALTY))
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.is_orisa_reloading, Math.INFINITY)
    eventPlayer.setMoveSpeed(100)


rule "[orisa/gun.opy]: Deal OW1 Orisa primary fire damage":
    @Event playerDealtDamage
    @Hero orisa
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, OW1_ORISA_GUN_DAMAGE - eventDamage)


rule "[orisa/gun.opy]: Deal OW1 Orisa melee damage":
    @Event playerDealtDamage
    @Hero orisa
    @Condition eventAbility == Button.MELEE

    damage(victim, attacker, eventDamage*(OW2_ORISA_GUN_DAMAGE/OW1_ORISA_GUN_DAMAGE) - eventDamage + 1) # +1 compensates for rounding error


rule "[orisa/gun.opy]: Reload after dying":
    @Event playerDied
    @Hero orisa

    resetFusionDriver()
