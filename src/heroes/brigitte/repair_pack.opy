#!mainFile "../../main.opy"

playervar repairpack
#!defineMember repair_pack_target repairpack[0]
#!defineMember repair_pack_travel_time repairpack[1]
#!defineMember repair_pack_id repairpack[2]


rule "[brigitte/repair.opy] OW1 Repair Pack":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.repair_pack_target = eventPlayer.getRealPlayerClosestToReticle(eventPlayer.getTeam())
    eventPlayer.repair_pack_travel_time = distance(eventPlayer.getPosition(), eventPlayer.repair_pack_target)
    wait(eventPlayer.repair_pack_travel_time/OW1_BRIGITTE_REPAIR_PACK_SPEED)
    eventPlayer.repair_pack_target.startHealingOverTime(eventPlayer, OW1_BRIGITTE_REPAIR_PACK_DURATION, OW1_BRIGITTE_REPAIR_PACK_HEALING/2)
    eventPlayer.repair_pack_id = getLastHealingOverTimeId()