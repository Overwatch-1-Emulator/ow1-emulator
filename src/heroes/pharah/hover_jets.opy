#!mainFile "../../main.opy"

playervar hover_jets_pvar
#!defineMember _fuel_gui hover_jets_pvar[0]
#!defineMember _hover_jet_button hover_jets_pvar[1]
#!defineMember _jet_dash_button hover_jets_pvar[2]
playervar jet_fuel

#!define isUsingHoverJets() \
    ((eventPlayer.isHoldingButton(eventPlayer._hover_jet_button)) \
 and (not eventPlayer.isOnGround()) \
 and (not eventPlayer.isJumping()) \
 and (not eventPlayer.isUsingUltimate()) \
 and (not isCCd(eventPlayer)) \
 and (eventPlayer.jet_fuel > 0)) \


#!define isGlidingOnRoof() \
    ((not eventPlayer.isOnGround()) \
 and (not eventPlayer.isJumping()) \
 and (eventPlayer.getAltitude() <= 0))

subroutine showFuelGui
subroutine hideFuelGui


#!define initHoverJets() \
    eventPlayer.jet_fuel = 100 \
    showFuelGui() \
    eventPlayer.setAbilityCooldown(Button.JUMP, Math.INFINITY) \
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, Math.INFINITY) \
    if (eventPlayer.getAbilityCooldown(Button.JUMP) == 0 and eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0): \
        eventPlayer._hover_jet_button = Button.JUMP \
        eventPlayer._jet_dash_button = Button.SECONDARY_FIRE \
    else: \
        eventPlayer._hover_jet_button = Button.SECONDARY_FIRE \
        eventPlayer._jet_dash_button = Button.JUMP \


rule "[pharah/hover_jets.opy]: Disable jet dash":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.getAbilityCooldown(eventPlayer._jet_dash_button) <= 1
    @Condition eventPlayer._jet_dash_button != null

    eventPlayer.setAbilityCooldown(eventPlayer._jet_dash_button, Math.INFINITY)


rule "[pharah/hover_jets.opy]: Consume fuel when using hover jets":
    @Event eachPlayer
    @Hero pharah
    @Condition isUsingHoverJets()

    eventPlayer.setMoveSpeed(percent(OW1_PHARAH_HOVER_JETS_SPEED_BOOST/OW2_PHARAH_HOVER_JETS_SPEED_BOOST))
    chase(eventPlayer.jet_fuel, 0, rate=OW1_PHARAH_HOVER_JETS_FUEL_CONSUMPTION_RATE, ChaseReeval.NONE)


rule "[pharah/hover_jets.opy]: Stop fuel consumption when not using hover jets":
    @Event eachPlayer
    @Hero pharah
    @Condition not isUsingHoverJets()

    eventPlayer.setMoveSpeed(100)
    stopChasingVariable(eventPlayer.jet_fuel)


rule "[pharah/hover_jets.opy]: Recharge hover jets":
    @Event eachPlayer
    @Hero pharah
    @Condition not isUsingHoverJets()
    @Condition not isGlidingOnRoof()

    wait(OW1_PHARAH_HOVER_JETS_RECOVERY_TIME, Wait.ABORT_WHEN_FALSE)
    chase(eventPlayer.jet_fuel, OW1_PHARAH_HOVER_JETS_MAX_FUEL, rate=OW1_PHARAH_HOVER_JETS_FUEL_RECHARGE_RATE, ChaseReeval.NONE)


rule "[pharah/hover_jets.opy]: Stop fuel recharge when gliding on roof":
    @Event eachPlayer
    @Hero pharah
    @Condition not isUsingHoverJets()
    @Condition isGlidingOnRoof()

    eventPlayer.setMoveSpeed(100)
    stopChasingVariable(eventPlayer.jet_fuel)


rule "[pharah/hover_jets.opy]: Disable hover jets when out of fuel":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.jet_fuel <= 0
    @Condition eventPlayer._hover_jet_button != null

    eventPlayer.disallowButton(eventPlayer._hover_jet_button)


rule "[pharah/hover_jets.opy]: Enable hover jets when fuel available":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.jet_fuel > 0
    @Condition eventPlayer._hover_jet_button != null

    eventPlayer.allowButton(eventPlayer._hover_jet_button)


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
