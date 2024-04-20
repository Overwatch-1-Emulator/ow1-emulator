#!mainFile "../../main.opy"

playervar repair_pvar

#!define isPressingSelfRepairButton(player)\
    (player.isHoldingButton(Button.ABILITY_2) \
  or player.isHoldingButton(Button.SECONDARY_FIRE))

#!define isUsingSelfRepair(player)\
    ((isPressingSelfRepairButton(player)) \
 and (not player.isFiringPrimaryFire()) \
 and (not player.isMeleeing()) \
 and (not isCCd(player)) \
 and (player.isAlive()) \
 and (player.self_repair_time_left > 0))

# Remove repair resource vfx
#!define hideSelfRepairResource()\
    destroyProgressBarHud(eventPlayer._self_repair_resource_gui)\
    eventPlayer._self_repair_resource_gui = null

# Remove repair sparks and ring vfx
#!define hideSelfRepairRing()\
    destroyEffect(eventPlayer._self_repair_sparkles_upper_gui)\
    eventPlayer._self_repair_sparkles_upper_gui = null\
    destroyEffect(eventPlayer._self_repair_sparkles_lower_gui)\
    eventPlayer._self_repair_sparkles_lower_gui = null\
    destroyEffect(eventPlayer._self_repair_ring_gui)\
    eventPlayer._self_repair_ring_gui = null

playervar self_repair_time_left
#!defineMember self_repair_instance repair_pvar[3]

#!defineMember _self_repair_resource_gui repair_pvar[4]
#!defineMember _self_repair_sparkles_upper_gui repair_pvar[5]
#!defineMember _self_repair_sparkles_lower_gui repair_pvar[6]
#!defineMember _self_repair_ring_gui repair_pvar[7]


rule "[bastion/repair.opy]: Activate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition isUsingSelfRepair(eventPlayer)

    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop resource recharging

    wait(OW1_BASTION_SELF_REPAIR_CAST_TIME, Wait.ABORT_WHEN_FALSE)

    # repair sparks and ring vfx
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


rule "[bastion/repair.opy]: Deactivate self-repair":
    @Event eachPlayer
    @Hero bastion
    @Condition not isUsingSelfRepair(eventPlayer)

    stopHoT(eventPlayer.self_repair_instance) # Stop healing
    eventPlayer.self_repair_instance = null

    hideSelfRepairRing()

    stopChasingVariable(eventPlayer.self_repair_time_left) # Stop resource depletion
    wait(OW1_BASTION_SELF_REPAIR_COOLDOWN_TIME, Wait.ABORT_WHEN_FALSE) # Wait 1 second cooldown before recharging heal resource

    chase(eventPlayer.self_repair_time_left, \
          OW1_BASTION_MAX_SELF_REPAIR_DURATION, \
          rate=OW1_BASTION_MAX_SELF_REPAIR_DURATION/OW1_BASTION_SELF_REPAIR_RECHARGE_DURATION, \
          ChaseReeval.DESTINATION_AND_RATE) # Start recharging


rule "[bastion/repair.opy]: Hide self repair resource GUI":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.self_repair_time_left >= OW1_BASTION_MAX_SELF_REPAIR_DURATION

    hideSelfRepairResource()


rule "[bastion/repair.opy]: Give ult charge for self repair":
    @Event playerDealtHealing
    @Hero bastion
    @Condition healer == healee

    eventPlayer._missing_ult_points += eventHealing
