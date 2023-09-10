#!mainFile "../../../main.opy"

playervar is_pressing_self_repair_key
playervar is_using_self_repair

playervar self_repair_time_left
playervar self_repair_instance

playervar self_repair_gui

subroutine createSelfRepairGUI
subroutine destroySelfRepairGUI


rule "[bastion/repair.opy]: Initialize self repair ability":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.call_init == true
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.self_repair_time_left = OW1_BASTION_MAX_SELF_REPAIR_DURATION
    eventPlayer.self_repair_gui = null
    eventPlayer.is_pressing_self_repair_key = false
    eventPlayer.is_using_self_repair = false


rule "[bastion/repair.opy]: Detect Self Repair key press":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    eventPlayer.is_pressing_self_repair_key = true
    waitUntil(not (eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)), Math.INFINITY)
    eventPlayer.is_pressing_self_repair_key = false


rule "[bastion/repair.opy]: Start self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.is_using_self_repair
    @Condition eventPlayer.is_pressing_self_repair_key
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.isAlive()

    if eventPlayer.self_repair_gui == null:
        createSelfRepairGUI()
    wait(OW1_BASTION_SELF_REPAIR_CAST_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.is_using_self_repair = true
    waitUntil(not eventPlayer.is_pressing_self_repair_key or \
              eventPlayer.isFiringPrimaryFire() or \
              eventPlayer.isDead() or \
              eventPlayer.self_repair_time_left <= 0, Math.INFINITY)
    eventPlayer.is_using_self_repair = false


rule "[bastion/repair.opy]: Heal on self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.is_using_self_repair

    eventPlayer.startHoT(eventPlayer, eventPlayer.self_repair_time_left, OW1_BASTION_SELF_REPAIR_HEALING_RATE)
    eventPlayer.self_repair_instance = getLastHoT()


rule "[bastion/repair.opy]: Deplete healing resource":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.is_using_self_repair

    chase(eventPlayer.self_repair_time_left, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE) # Start depleting


rule "[bastion/repair.opy]: Stop healing when not self-repairing":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.is_using_self_repair

    stopHoT(eventPlayer.self_repair_instance)


rule "[bastion/repair.opy]: Replanish healing resource":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.is_using_self_repair

    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop any ongoing resource modification
    wait(OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME) # Wait 1 second cooldown before recharging heal resource
    chase(eventPlayer.self_repair_time_left, \
          OW1_BASTION_MAX_SELF_REPAIR_DURATION, \
          rate=OW1_BASTION_MAX_SELF_REPAIR_DURATION/OW1_BASTION_SELF_REPAIR_RECHARGE_DURATION, \
          ChaseReeval.DESTINATION_AND_RATE) # Start recharging


rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer.missing_ult_points += eventHealing


def createSelfRepairGUI():
    @Name "[bastion/repair.opy]: createSelfRepairGUI()"

    progressBarHud(eventPlayer, 
                   roundedPercent(eventPlayer.self_repair_time_left/OW1_BASTION_MAX_SELF_REPAIR_DURATION), 
                   "Self-Repair", 
                   HudPosition.LEFT, 
                   1, 
                   Color.YELLOW, 
                   Color.YELLOW, 
                   ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
                   SpecVisibility.DEFAULT)
    eventPlayer.self_repair_gui = getLastCreatedText()


def destroySelfRepairGUI():
    @Name "[bastion/repair.opy]: destroySelfRepairGUI()"

    destroyProgressBarHud(eventPlayer.self_repair_gui)
    eventPlayer.self_repair_gui = null


rule "[bastion/repair.opy]: Hide self-repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left >= OW1_BASTION_MAX_SELF_REPAIR_DURATION

    destroySelfRepairGUI()
