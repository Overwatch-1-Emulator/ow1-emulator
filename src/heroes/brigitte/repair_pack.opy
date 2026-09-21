#!mainFile "../../main.opy"

# getTotalTimeElapsed() when this player's Repair Pack healing ends (timestamp instead of a chased timer)
playervar repair_pack_end_time
playervar repair_pack
#!defineMember repair_pack_target      repair_pack[0]
#!defineMember repair_pack_travel_time repair_pack[1]
#!defineMember repair_pack_id          repair_pack[2]


rule "[brigitte/repair.opy] OW1 Repair Pack":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.repair_pack_target = eventPlayer.getRealPlayerClosestToReticle(eventPlayer.getTeam())
    eventPlayer.repair_pack_travel_time = distance(eventPlayer.getPosition(), eventPlayer.repair_pack_target)
    wait(eventPlayer.repair_pack_travel_time/OW1_BRIGITTE_REPAIR_PACK_SPEED)
    # Extra packs add their duration to whatever is left, like the old += did
    if eventPlayer.repair_pack_target.repair_pack_id == null:
        eventPlayer.repair_pack_target.startHealingOverTime(eventPlayer, Math.INFINITY, OW1_BRIGITTE_REPAIR_PACK_HEALING)
        eventPlayer.repair_pack_target.repair_pack_id = getLastHealingOverTimeId()
    eventPlayer.repair_pack_target.repair_pack_end_time = max(eventPlayer.repair_pack_target.repair_pack_end_time, getTotalTimeElapsed()) + OW1_BRIGITTE_REPAIR_PACK_DURATION



rule "[brigitte/repair.opy]: End Repair pack healing":
    @Event eachPlayer
    @Condition eventPlayer.repair_pack_id != null # cheap gate: only players with an active pack
    @Condition getTotalTimeElapsed() < eventPlayer.repair_pack_end_time

    # Re-reads the end time every tick, so extra packs extend the healing
    waitUntil(getTotalTimeElapsed() >= eventPlayer.repair_pack_end_time, Math.INFINITY)
    #eventPlayer.setHealth(eventPlayer.getHealth() - 0.88) # Interal rounding error, Don't remove this!
    stopHealingOverTime(eventPlayer.repair_pack_id)
    eventPlayer.repair_pack_id = null
