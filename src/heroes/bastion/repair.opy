#!mainFile "../../main.opy"

playervar repair_pvar

#!defineMember is_pressing_self_repair_key repair_pvar[0]
#!defineMember is_using_self_repair repair_pvar[1]

playervar self_repair_time_left
#!defineMember self_repair_instance repair_pvar[3]

#!defineMember _self_repair_resource_gui repair_pvar[4]
#!defineMember _self_repair_sparkles_upper_gui repair_pvar[5]
#!defineMember _self_repair_sparkles_lower_gui repair_pvar[6]
#!defineMember _self_repair_ring_gui repair_pvar[7]

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
    @Condition not (eventPlayer.isFiringPrimaryFire() or eventPlayer.isMeleeing() or eventPlayer.isDead() or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.STUNNED))
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
    eventPlayer.is_using_self_repair = false
    wait(OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME) # Wait 1 second cooldown before recharging heal resource
    chase(eventPlayer.self_repair_time_left, \
          OW1_BASTION_MAX_SELF_REPAIR_DURATION, \
          rate=OW1_BASTION_MAX_SELF_REPAIR_DURATION/OW1_BASTION_SELF_REPAIR_RECHARGE_DURATION, \
          ChaseReeval.DESTINATION_AND_RATE) # Start recharging


rule "[bastion/repair.opy]: Remove self repair GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left >= OW1_BASTION_MAX_SELF_REPAIR_DURATION

    hideSelfRepairGui()


rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer._missing_ult_points += eventHealing


def showSelfRepairGui():
    @Name "[bastion/repair.opy]: showSelfRepairGui()"

    if eventPlayer._self_repair_resource_gui == null:
        progressBarHud(eventPlayer if eventPlayer.self_repair_time_left < OW1_BASTION_MAX_SELF_REPAIR_DURATION else null, 
                        roundedPercent(eventPlayer.self_repair_time_left/OW1_BASTION_MAX_SELF_REPAIR_DURATION), 
                        "Self-Repair", 
                        HudPosition.TOP, 
                        1, 
                        Color.YELLOW, 
                        Color.YELLOW, 
                        ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, 
                        SpecVisibility.DEFAULT)
        eventPlayer._self_repair_resource_gui = getLastCreatedText()


def hideSelfRepairGui():
    @Name "[bastion/repair.opy]: hideSelfRepairGui()"

    destroyProgressBarHud(eventPlayer._self_repair_resource_gui)
    eventPlayer._self_repair_resource_gui = null


rule "[bastion/repair.opy]: Show self-repair ring":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.is_using_self_repair

    if eventPlayer._self_repair_sparkles_upper_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.SPARKLES, 
                     Color.YELLOW, 
                     updateEveryTick(eventPlayer.getEyePosition()), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_upper_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_sparkles_lower_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.SPARKLES, 
                     Color.YELLOW, 
                     updateEveryTick((eventPlayer.getEyePosition()+eventPlayer.getPosition())/2), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_lower_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_ring_gui == null:
        createEffect(getAllPlayers(), 
                     Effect.LIGHT_SHAFT, 
                     Color.YELLOW, 
                     updateEveryTick(eventPlayer.getPosition()), 
                     1.5, 
                     EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer._self_repair_ring_gui = getLastCreatedEntity()


rule "[bastion/repair.opy]: Hide self-repair ring":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.is_using_self_repair

    destroyEffect(eventPlayer._self_repair_sparkles_upper_gui)
    eventPlayer._self_repair_sparkles_upper_gui = null
    destroyEffect(eventPlayer._self_repair_sparkles_lower_gui)
    eventPlayer._self_repair_sparkles_lower_gui = null
    destroyEffect(eventPlayer._self_repair_ring_gui)
    eventPlayer._self_repair_ring_gui = null
