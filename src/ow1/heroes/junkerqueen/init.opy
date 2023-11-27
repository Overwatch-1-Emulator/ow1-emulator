#!mainFile "../../../main.opy"

playervar jq_self_heal_id


rule "[junkerqueen/init.opy]: Initialize Junkerqueen":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.call_init
    
    newHero(OW1_JUNKERQUEEN_HEALTH, OW1_JUNKERQUEEN_ARMOR, 0)

    startHealingModification(eventPlayer, eventPlayer, percent(OW1_JUNKERQUEEN_ADRENALINE/OW2_JUNKERQUEEN_ADRENALINE), HealingReeval.NONE)
    eventPlayer.jq_self_heal_id = getLastHealingModification()
    removeTankPassive()
    
    eventPlayer.call_init = false


rule "[orisa/init.opy]: Clean up Junkerqueen":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.JUNKER_QUEEN

    stopHealingModification(eventPlayer.jq_self_heal_id)


# #!include "ow1/heroes/junkerqueen/shout.opy"
# #!include "ow1/heroes/junkerqueen/carnage.opy"
