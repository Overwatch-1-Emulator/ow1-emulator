#!mainFile "../../main.opy"

playervar self_healing_percent
playervar self_healing_modification

subroutine removeSelfHealing

def removeSelfHealing():
    @Name "[no_support_passive.opy]: removeSelfHealing()"

    eventPlayer.self_healing_percent = 0
    startHealingModification(eventPlayer, eventPlayer, eventPlayer.self_healing_percent, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.self_healing_modification = getLastHealingModification()