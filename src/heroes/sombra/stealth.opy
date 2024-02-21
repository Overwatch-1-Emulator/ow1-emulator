#!mainFile "../../main.opy"

playervar is_using_stealth
playervar stealth_hud_id

subroutine enterStealth
subroutine exitStealth
subroutine showStealthHud
subroutine hideStealthHud


rule "[sombra/stealth.opy]: Remove Stealth passive":
    @Event eachPlayer
    @Hero sombra
    @Condition not eventPlayer.is_using_stealth
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isMeleeing()

    do:
        damage(eventPlayer, null, MIN_DAMAGE)
        wait(cosDeg(1), Wait.ABORT_WHEN_FALSE) # some irrational value
        # explanation: since stealth passive activates every 3.5 seconds
        # damage must be applied in a way that never synchronizes with passive stealth activation
    while RULE_CONDITION:


rule "[sombra/stealth.opy]: Bind Ability 1 to stealth":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0
    @Condition not eventPlayer.is_using_stealth

    enterStealth()


def enterStealth():
    @Name "[sombra/stealth.opy]: enterStealth()"

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setSecondaryFireEnabled(false) # Disable hacking during invis
    showStealthHud()
    wait(OW1_SOMBRA_STEALTH_CAST_TIME)
    eventPlayer.setInvisibility(Invis.ENEMIES)
    eventPlayer.setMoveSpeed(percent(OW1_SOMBRA_STEALTH_MOVEMENT_BONUS))
    eventPlayer.is_using_stealth = true
    damage(eventPlayer, null, 0.01)
    heal(eventPlayer, null, 0.01)
    wait(OW2_SOMBRA_STEALTH_COOLDOWN)
    wait(OW2_SOMBRA_STEALTH_CAST_TIME)
    hideStealthHud()
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.setMoveSpeed(percent(OW1_SOMBRA_STEALTH_MOVEMENT_BONUS/OW2_SOMBRA_STEALTH_MOVEMENT_BONUS))


rule "[sombra/stealth.opy]: Exit Stealth when shooting":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.is_using_stealth
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) \
            or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) \
            or eventPlayer.isHoldingButton(Button.MELEE) \
            or eventPlayer.isHoldingButton(Button.ABILITY_1) \
            or eventPlayer.isHoldingButton(Button.ULTIMATE)

    exitStealth()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_SOMBRA_STEALTH_COOLDOWN)


rule "[sombra/stealth.opy]: Exit Stealth when taking damage":
    @Event playerTookDamage
    @Hero sombra
    @Condition eventPlayer.is_using_stealth

    exitStealth()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_SOMBRA_STEALTH_COOLDOWN)


def exitStealth():
    @Name "[sombra/stealth.opy]: exitStealth()"

    damage(eventPlayer, null, 0.01)
    heal(eventPlayer, null, 0.01)
    eventPlayer.setSecondaryFireEnabled(true) # Enable hacking after exiting invis
    eventPlayer.setInvisibility(Invis.NONE)
    eventPlayer.setMoveSpeed(100)
    hideStealthHud()
    wait(OW1_SOMBRA_STEALTH_RECOVERY_TIME)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.is_using_stealth = false


def showStealthHud():
    @Name "[sombra/stealth.opy]: showStealthHud()"

    if eventPlayer.stealth_hud_id == null:
        createEffect(eventPlayer, Effect.SPHERE, rgb(100, 68, 179), eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.stealth_hud_id = getLastCreatedEntity()


def hideStealthHud():
    @Name "[sombra/stealth.opy]: hideStealthHud()"

    destroyEffect(eventPlayer.stealth_hud_id)
    eventPlayer.stealth_hud_id = null
