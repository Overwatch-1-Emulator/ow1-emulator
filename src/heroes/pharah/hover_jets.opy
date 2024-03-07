#!mainFile "../../main.opy"

playervar hover_jets_pvar
#!defineMember _fuel_gui hover_jets_pvar[0]
playervar jet_fuel

#!define is_using_hover_jets() \
    ((eventPlayer.isHoldingButton(Button.JUMP)) \
 and (not eventPlayer.isOnGround()) \
 and (not eventPlayer.isJumping()) \
 and (not eventPlayer.isUsingUltimate()) \
 and (not isCCd(eventPlayer)) \
 and (eventPlayer.jet_fuel > 0)) \

subroutine showFuelGui
subroutine hideFuelGui

rule "[pharah/hover_jets.opy]: Activate OW1 hover jets":
    @Event eachPlayer
    @Hero pharah
    @Condition updateEveryTick(is_using_hover_jets())

    eventPlayer.setMoveSpeed(percent(OW1_PHARAH_HOVER_JETS_SPEED_BOOST/OW2_PHARAH_HOVER_JETS_SPEED_BOOST))
    chase(eventPlayer.jet_fuel, 0, rate=OW1_PHARAH_HOVER_JETS_FUEL_CONSUMPTION_RATE, ChaseReeval.NONE)


rule "[pharah/hover_jets.opy]: Deactivate OW1 hover jets":
    @Event eachPlayer
    @Hero pharah
    @Condition updateEveryTick(not is_using_hover_jets())

    eventPlayer.setMoveSpeed(100)
    stopChasingVariable(eventPlayer.jet_fuel)
    wait(OW1_PHARAH_HOVER_JETS_RECOVERY_TIME, Wait.ABORT_WHEN_FALSE)
    chase(eventPlayer.jet_fuel, OW1_PHARAH_HOVER_JETS_MAX_FUEL, rate=OW1_PHARAH_HOVER_JETS_FUEL_RECHARGE_RATE, ChaseReeval.NONE)


rule "[pharah/hover_jets.opy]: Disable hover jets when out of fuel":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.jet_fuel <= 0

    eventPlayer.disallowButton(Button.JUMP)


rule "[pharah/hover_jets.opy]: Enable hover jets when fuel available":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.jet_fuel > 0

    eventPlayer.allowButton(Button.JUMP)


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
