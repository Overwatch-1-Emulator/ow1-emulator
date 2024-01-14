#!mainFile "../../main.opy"

playervar jq_self_heal_id


rule "[junkerqueen/init.opy]: Detect switch to Junkerqueen":
    @Event eachPlayer
    @Hero junkerQueen

    eventPlayer.call_init = true


rule "[junkerqueen/init.opy]: Initialize Junkerqueen":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.call_init
    
    newHero(OW1_JUNKERQUEEN_HEALTH, OW1_JUNKERQUEEN_ARMOR, 0)
    setUltCost(OW1_JUNKERQUEEN_ULT_COST)

    startHealingModification(eventPlayer, eventPlayer, percent(OW1_JUNKERQUEEN_ADRENALINE/OW2_JUNKERQUEEN_ADRENALINE), HealingReeval.NONE)
    eventPlayer.jq_self_heal_id = getLastHealingModification()
    removeTankPassive()
    
    eventPlayer.call_init = false


rule "[junkerqueen/init.opy]: Clean up Junkerqueen":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.JUNKER_QUEEN

    stopHealingModification(eventPlayer.jq_self_heal_id)


# #!include "heroes/junkerqueen/shout.opy"
# #!include "heroes/junkerqueen/carnage.opy"
