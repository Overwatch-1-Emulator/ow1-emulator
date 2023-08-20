#!mainFile "../../../main.opy"

playervar self_repair_time_left
playervar self_repair_instance

playervar self_repair_gui

subroutine startSelfRepair
subroutine stopSelfRepair

subroutine createSelfRepairGUI
subroutine destroySelfRepairGUI


rule "[bastion/repair.opy]: Initialize self repair ability":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.call_init == true
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.self_repair_time_left = OW1_BASTION_MAX_SELF_REPAIR_DURATION


def startSelfRepair():
    @Name "[bastion/repair.opy]: startSelfRepair()"
    
    wait(OW1_BASTION_SELF_REPAIR_CAST_TIME)
    eventPlayer.startHoT(eventPlayer, eventPlayer.self_repair_time_left, OW1_BASTION_SELF_REPAIR_HEALING_RATE)
    eventPlayer.self_repair_instance = getLastHoT()
    chase(eventPlayer.self_repair_time_left, \
          0, \
          rate=1, \
          ChaseReeval.DESTINATION_AND_RATE) # Start depleting


def stopSelfRepair():
    @Name "[bastion/repair.opy]: stopSelfRepair()"
    
    stopHoT(eventPlayer.self_repair_instance)
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


rule "[bastion/repair.opy]: Start self-repair on ability 2 or secondary fire":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    @Condition eventPlayer.isDead() == false
    
    startSelfRepair()


rule "[bastion/repair.opy]: Stop self-repair on key release":
    @Event eachPlayer
    @Hero bastion
    @Condition not (eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE))\
               or eventPlayer.isFiringPrimaryFire()

    stopSelfRepair()


rule "[bastion/repair.opy]: Stop self-repair and hide its GUI on death":
    @Event playerDied
    @Hero bastion

    stopSelfRepair()


rule "[bastion/repair.opy]: Stop self-repair when no healing resource left":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left <= 0

    stopSelfRepair()


rule "[bastion/repair.opy]: Stop self-repair when full hp":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.getHealth() >= eventPlayer.getMaxHealth()

    stopSelfRepair()


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


rule "[bastion/repair.opy]: Show self-repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left < OW1_BASTION_MAX_SELF_REPAIR_DURATION

    createSelfRepairGUI()


rule "[bastion/repair.opy]: Hide self-repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left >= OW1_BASTION_MAX_SELF_REPAIR_DURATION

    destroySelfRepairGUI()
