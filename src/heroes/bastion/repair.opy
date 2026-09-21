#!mainFile "../../main.opy"

subroutine showSelfRepairGui

playervar self_repair_time_left

playervar repair_pvar
#!defineMember self_repair_instance repair_pvar[3]
#!defineMember _self_repair_resource_gui repair_pvar[4]
#!defineMember _self_repair_sparkles_upper_gui repair_pvar[5]
#!defineMember _self_repair_sparkles_lower_gui repair_pvar[6]
#!defineMember _self_repair_ring_gui repair_pvar[7]

macro isPressingSelfRepairButton(player):
    (player.isHoldingButton(Button.ABILITY_2)
  or player.isHoldingButton(Button.SECONDARY_FIRE))

macro isUsingSelfRepair(player):
    ((isPressingSelfRepairButton(player))
 and (not player.isFiringPrimaryFire())
 and (not player.isMeleeing())
 and (not isCCd(player))
 and (player.isAlive())
 and (player.self_repair_time_left > 0))

# Remove repair resource vfx
macro hideSelfRepairResource():
    destroyProgressBarHud(eventPlayer._self_repair_resource_gui)
    eventPlayer._self_repair_resource_gui = null

# Remove repair sparks and ring vfx
macro hideSelfRepairRing():
    destroyEffect(eventPlayer._self_repair_sparkles_upper_gui)
    eventPlayer._self_repair_sparkles_upper_gui = null
    destroyEffect(eventPlayer._self_repair_sparkles_lower_gui)
    eventPlayer._self_repair_sparkles_lower_gui = null
    destroyEffect(eventPlayer._self_repair_ring_gui)
    eventPlayer._self_repair_ring_gui = null


# One rule for activating, stopping and recharging self-repair (replaces three rules).
# self_repair_time_left is chased, so running out and refilling are watched with
# waitUntil here instead of in rule conditions, which may not fire on OW2.
rule "[bastion/repair.opy]: Self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isAlive()

    do:
        if isUsingSelfRepair(eventPlayer):
            stopChasingVariable(eventPlayer.self_repair_time_left) # Stop resource recharging

            # Cast time; cancelled if the player stops self-repairing
            waitUntil(not isUsingSelfRepair(eventPlayer), OW1_BASTION_SELF_REPAIR_CAST_TIME)
            if isUsingSelfRepair(eventPlayer):
                showSelfRepairGui()
                waitUntil(not isUsingSelfRepair(eventPlayer), Math.INFINITY) # released, CC'd or resource empty

            # Deactivate
            stopHoT(eventPlayer.self_repair_instance) # Stop healing
            eventPlayer.self_repair_instance = null
            hideSelfRepairRing()
            stopChasingVariable(eventPlayer.self_repair_time_left) # Stop resource depletion
        else:
            # 1 second cooldown before recharging, unless self-repair starts again
            waitUntil(isUsingSelfRepair(eventPlayer), OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME)
            if not isUsingSelfRepair(eventPlayer):
                chase(eventPlayer.self_repair_time_left, \
                      OW1_BASTION_MAX_SELF_REPAIR_DURATION, \
                      rate=OW1_BASTION_MAX_SELF_REPAIR_DURATION/OW1_BASTION_SELF_REPAIR_RECHARGE_DURATION, \
                      ChaseReeval.DESTINATION_AND_RATE) # Start recharging
                waitUntil(isUsingSelfRepair(eventPlayer) or eventPlayer.self_repair_time_left >= OW1_BASTION_MAX_SELF_REPAIR_DURATION, Math.INFINITY)
                if eventPlayer.self_repair_time_left >= OW1_BASTION_MAX_SELF_REPAIR_DURATION:
                    hideSelfRepairResource() # full: hide the resource bar
                    waitUntil(isUsingSelfRepair(eventPlayer), Math.INFINITY)
    while RULE_CONDITION


def showSelfRepairGui():
    @Name "[bastion/repair.opy]: showSelfRepairGui()"

    # repair sparks and ring vfx
    if eventPlayer._self_repair_sparkles_upper_gui == null:
        createEffect(getAllPlayers(),
                     Effect.SPARKLES,
                     Color.YELLOW,
                     updateEveryTick(eventPlayer.getEyePosition()),
                     1.5,
                     EffectReeval.POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_upper_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_sparkles_lower_gui == null:
        createEffect(getAllPlayers(),
                     Effect.SPARKLES,
                     Color.YELLOW,
                     updateEveryTick((eventPlayer.getEyePosition()+eventPlayer.getPosition())/2),
                     1.5,
                     EffectReeval.POSITION_AND_RADIUS)
        eventPlayer._self_repair_sparkles_lower_gui = getLastCreatedEntity()

    if eventPlayer._self_repair_ring_gui == null:
        createEffect(getAllPlayers(),
                     Effect.LIGHT_SHAFT,
                     Color.YELLOW,
                     updateEveryTick(eventPlayer.getPosition()),
                     1.5,
                     EffectReeval.POSITION_AND_RADIUS)
        eventPlayer._self_repair_ring_gui = getLastCreatedEntity()

    # resource bar vfx
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

    if eventPlayer.self_repair_instance == null:
        eventPlayer.startHoT(eventPlayer, eventPlayer.self_repair_time_left, OW1_BASTION_SELF_REPAIR_HEALING_RATE)
        eventPlayer.self_repair_instance = getLastHoT()
    chase(eventPlayer.self_repair_time_left, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE) # Start resource depletion


rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer._missing_ult_points += eventHealing
