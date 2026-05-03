#!mainFile "../../main.opy"

playervar repairpack
#!defineMember repair_pack_target repairpack[0]
#!defineMember repair_pack_travel_time repairpack[1]
#!defineMember repair_pack_id repairpack[2]
playervar repair_pack_duration


rule "[brigitte/repair.opy] OW1 Repair Pack":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.repair_pack_target = eventPlayer.getRealPlayerClosestToReticle(eventPlayer.getTeam())
    eventPlayer.repair_pack_travel_time = distance(eventPlayer.getPosition(), eventPlayer.repair_pack_target)
    wait(eventPlayer.repair_pack_travel_time/OW1_BRIGITTE_REPAIR_PACK_SPEED)
    eventPlayer.repair_pack_target.repair_pack_duration += OW1_BRIGITTE_REPAIR_PACK_DURATION
    if eventPlayer.repair_pack_target.repair_pack_id == null:
        eventPlayer.repair_pack_target.startHealingOverTime(eventPlayer, 999, OW1_BRIGITTE_REPAIR_PACK_HEALING)
        eventPlayer.repair_pack_target.repair_pack_id = getLastHealingOverTimeId()



rule "[brigitte/repair.opy]: Chase Duration":
    @Event eachPlayer
    @Condition eventPlayer.repair_pack_duration > 0

    chase(eventPlayer.repair_pack_duration, 0, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.repair_pack_duration <= 0)
    damage(eventPlayer, null, 0.88) #internal round up is 110.88/220.88/330.88 so this js removes that
    stopChasingVariable(eventPlayer.repair_pack_duration)
    stopHealingOverTime(eventPlayer.repair_pack_id)
    eventPlayer.repair_pack_id = null
