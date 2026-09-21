#!mainFile "../../main.opy"

playervar hover_jets_pvar
#!defineMember _fuel_gui hover_jets_pvar[0]
#!defineMember _hover_jet_button hover_jets_pvar[1]
#!defineMember _jet_dash_button hover_jets_pvar[2]
playervar jet_fuel

macro isUsingHoverJets():
    ((eventPlayer.isHoldingButton(eventPlayer._hover_jet_button)) \
 and (not eventPlayer.isOnGround()) \
 and (not eventPlayer.isJumping()) \
 and (not eventPlayer.isUsingUltimate()) \
 and (not isCCd(eventPlayer)) \
 and (eventPlayer.jet_fuel > 0)) \


macro isGlidingOnRoof():
    ((not eventPlayer.isOnGround()) \
 and (not eventPlayer.isJumping()) \
 and (eventPlayer.getAltitude() <= 0))

subroutine showFuelGui
subroutine hideFuelGui


macro initHoverJets():
    eventPlayer.jet_fuel = 100
    showFuelGui()
    eventPlayer.setAbilityCooldown(Button.JUMP, Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, Math.INFINITY)
    if (eventPlayer.getAbilityCooldown(Button.JUMP) == 0 and eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0):
        eventPlayer._hover_jet_button = Button.JUMP
        eventPlayer._jet_dash_button = Button.SECONDARY_FIRE
    else:
        eventPlayer._hover_jet_button = Button.SECONDARY_FIRE
        eventPlayer._jet_dash_button = Button.JUMP


rule "[pharah/hover_jets.opy]: Disable jet dash":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.getAbilityCooldown(eventPlayer._jet_dash_button) <= 1
    @Condition eventPlayer._jet_dash_button != null

    eventPlayer.setAbilityCooldown(eventPlayer._jet_dash_button, Math.INFINITY)


# One rule for hovering, recharging and roof gliding (replaces three rules).
# jet_fuel is chased, so every fuel-based transition is watched with waitUntil
# here instead of in rule conditions, which may not fire on OW2.
# OW1 behavior kept: no hover without fuel (isUsingHoverJets() needs fuel > 0), fuel
# recharges in the air after a short delay whenever not hovering, and gliding on a
# roof does not recharge.
rule "[pharah/hover_jets.opy]: Hover jets fuel":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer._hover_jet_button != null

    do:
        if isUsingHoverJets():
            # Hovering: burn fuel until hover stops (released, landed, CC'd or out of fuel)
            setMoveModifier(eventPlayer, MoveMod.HOVER_JETS, OW1_PHARAH_HOVER_JETS_SPEED_BOOST/OW2_PHARAH_HOVER_JETS_SPEED_BOOST)
            chase(eventPlayer.jet_fuel, 0, rate=OW1_PHARAH_HOVER_JETS_FUEL_CONSUMPTION_RATE, ChaseReeval.NONE)
            waitUntil(not isUsingHoverJets(), Math.INFINITY)
            clearMoveModifier(eventPlayer, MoveMod.HOVER_JETS)
            stopChasingVariable(eventPlayer.jet_fuel)
        elif isGlidingOnRoof():
            # Gliding on a roof: no recharge until hovering again or off the roof
            waitUntil(isUsingHoverJets() or not isGlidingOnRoof(), Math.INFINITY)
        else:
            # Recharge after the delay, unless hovering or roof gliding starts first
            waitUntil(isUsingHoverJets() or isGlidingOnRoof(), OW1_PHARAH_HOVER_JETS_RECOVERY_TIME)
            if not isUsingHoverJets() and not isGlidingOnRoof():
                chase(eventPlayer.jet_fuel, OW1_PHARAH_HOVER_JETS_MAX_FUEL, rate=OW1_PHARAH_HOVER_JETS_FUEL_RECHARGE_RATE, ChaseReeval.NONE)
                waitUntil(isUsingHoverJets() or isGlidingOnRoof(), Math.INFINITY)
                stopChasingVariable(eventPlayer.jet_fuel)
    while RULE_CONDITION


rule "[pharah/hover_jets.opy]: Gate hover jets on fuel":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer._hover_jet_button != null

    # Same reason as above: fuel thresholds checked in waitUntil, not conditions
    eventPlayer.allowButton(eventPlayer._hover_jet_button)
    waitUntil(eventPlayer.jet_fuel <= 0, Math.INFINITY)
    eventPlayer.disallowButton(eventPlayer._hover_jet_button)
    waitUntil(eventPlayer.jet_fuel > 0, Math.INFINITY)
    if RULE_CONDITION: goto RULE_START


def showFuelGui():
    @Name "[pharah/hover_jets.opy]: showFuelGui()"

    if eventPlayer._fuel_gui == null:
        progressBarHud(eventPlayer if eventPlayer.jet_fuel < OW1_PHARAH_HOVER_JETS_MAX_FUEL else null,
                        roundedPercent(eventPlayer.jet_fuel/OW1_PHARAH_HOVER_JETS_MAX_FUEL),
                        "Fuel",
                        HudPosition.TOP,
                        Math.INFINITY,
                        Color.WHITE,
                        Color.WHITE,
                        ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR,
                        SpecVisibility.DEFAULT)
        eventPlayer._fuel_gui = getLastCreatedText()


def hideFuelGui():
    @Name "[pharah/hover_jets.opy]: hideFuelGui()"

    destroyProgressBarHud(eventPlayer._fuel_gui)
    eventPlayer._fuel_gui = null
