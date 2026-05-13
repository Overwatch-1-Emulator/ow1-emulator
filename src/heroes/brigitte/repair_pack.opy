#!mainFile "../../main.opy"

playervar repair_pack_duration_pvar
#!defineMember repair_pack_target      repair_pack_duration_pvar[0]
#!defineMember repair_pack_travel_time repair_pack_duration_pvar[1]
#!defineMember repair_pack_id          repair_pack_duration_pvar[2]


rule "[brigitte/repair.opy] OW1 Repair Pack":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.repair_pack_target = eventPlayer.getRealPlayerClosestToReticle(eventPlayer.getTeam())
    eventPlayer.repair_pack_travel_time = distance(eventPlayer.getPosition(), eventPlayer.repair_pack_target)
    wait(eventPlayer.repair_pack_travel_time/OW1_BRIGITTE_REPAIR_PACK_SPEED)
    eventPlayer.repair_pack_target.repair_pack_duration += OW1_BRIGITTE_REPAIR_PACK_DURATION
    if eventPlayer.repair_pack_target.repair_pack_id == null:
        eventPlayer.repair_pack_target.startHealingOverTime(eventPlayer, Math.INFINITY, OW1_BRIGITTE_REPAIR_PACK_HEALING)
        eventPlayer.repair_pack_target.repair_pack_id = getLastHealingOverTimeId()



rule "[brigitte/repair.opy]: Chase Repair pack duration":
    @Event eachPlayer
    @Condition eventPlayer.repair_pack_duration > 0

    chase(eventPlayer.repair_pack_duration, 0, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.repair_pack_duration <= 0)
    eventPlayer.setHealth(eventPlayer.getHealth() - 0.88) # Interal rounding error, Don't remove this!
    stopChasingVariable(eventPlayer.repair_pack_duration)
    stopHealingOverTime(eventPlayer.repair_pack_id)
    eventPlayer.repair_pack_id = null
