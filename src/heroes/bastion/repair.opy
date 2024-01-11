#!mainFile "../../main.opy"

playervar is_pressing_self_repair_key
playervar is_using_self_repair

playervar self_repair_time_left
playervar self_repair_instance

playervar self_repair_gui

subroutine enterSelfRepair
subroutine exitSelfRepair
subroutine showSelfRepairGui
subroutine hideSelfRepairGui


rule "[bastion/repair.opy]: Detect Self Repair key press":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    eventPlayer.is_pressing_self_repair_key = true
    waitUntil(not (eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)), Math.INFINITY)
    eventPlayer.is_pressing_self_repair_key = false


rule "[bastion/repair.opy]: Activate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition not (eventPlayer.isFiringPrimaryFire() or eventPlayer.isMeleeing())
    @Condition eventPlayer.is_pressing_self_repair_key
    @Condition not eventPlayer.is_using_self_repair
    
    enterSelfRepair()


rule "[bastion/repair.opy]: Deactivate self-repair on key release":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.is_using_self_repair
    @Condition not eventPlayer.is_pressing_self_repair_key

    exitSelfRepair()


rule "[bastion/repair.opy]: Deactivate self-repair when resource exhuasted":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left <= 0
    @Condition eventPlayer.is_using_self_repair

    exitSelfRepair()


rule "[bastion/repair.opy]: Deactivate self-repair when dealing damage":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.is_using_self_repair
    @Condition eventPlayer.isFiringPrimaryFire() or eventPlayer.isMeleeing()

    exitSelfRepair()


def enterSelfRepair():
    @Name "[bastion/repair.opy]: enterSelfRepair()"

    showSelfRepairGui()
    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop resource recharging
    wait(OW1_BASTION_SELF_REPAIR_CAST_TIME)
    if eventPlayer.self_repair_instance == null:
        eventPlayer.startHoT(eventPlayer, eventPlayer.self_repair_time_left, OW1_BASTION_SELF_REPAIR_HEALING_RATE)
        eventPlayer.self_repair_instance = getLastHoT()
    chase(eventPlayer.self_repair_time_left, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE) # Start resource depletion
    eventPlayer.is_using_self_repair = true


def exitSelfRepair():
    @Name "[bastion/repair.opy]: exitSelfRepair()"

    stopHoT(eventPlayer.self_repair_instance) # Stop healing
    eventPlayer.self_repair_instance = null
    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop resource depletion
    wait(OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME) # Wait 1 second cooldown before recharging heal resource
    chase(eventPlayer.self_repair_time_left, \
          OW1_BASTION_MAX_SELF_REPAIR_DURATION, \
          rate=OW1_BASTION_MAX_SELF_REPAIR_DURATION/OW1_BASTION_SELF_REPAIR_RECHARGE_DURATION, \
          ChaseReeval.DESTINATION_AND_RATE) # Start recharging
    eventPlayer.is_using_self_repair = false


rule "[bastion/repair.opy]: Remove self repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left >= OW1_BASTION_MAX_SELF_REPAIR_DURATION

    hideSelfRepairGui()


rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer.missing_ult_points += eventHealing


def showSelfRepairGui():
    @Name "[bastion/repair.opy]: showSelfRepairGui()"

    if eventPlayer.self_repair_gui != null:
        return
    progressBarHud(eventPlayer if eventPlayer.self_repair_time_left < OW1_BASTION_MAX_SELF_REPAIR_DURATION else null, 
                   roundedPercent(eventPlayer.self_repair_time_left/OW1_BASTION_MAX_SELF_REPAIR_DURATION), 
                   "Self-Repair", 
                   HudPosition.TOP, 
                   1, 
                   Color.YELLOW, 
                   Color.YELLOW, 
                   ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
                   SpecVisibility.DEFAULT)
    eventPlayer.self_repair_gui = getLastCreatedText()


def hideSelfRepairGui():
    @Name "[bastion/repair.opy]: hideSelfRepairGui()"

    destroyProgressBarHud(eventPlayer.self_repair_gui)
    eventPlayer.self_repair_gui = null
