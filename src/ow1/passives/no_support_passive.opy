#!mainFile "../../main.opy"

playervar self_healing_percent
playervar self_healing_modification
playervar support_passive_active
playervar last_time_damage_taken

subroutine removeSelfHealing

def removeSelfHealing():
    @Name "[no_support_passive.opy]: removeSelfHealing()"

    eventPlayer.self_healing_percent = 0
    startHealingModification(eventPlayer, eventPlayer, eventPlayer.self_healing_percent, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.self_healing_modification = getLastHealingModification()



rule "[no_support_passive.opy]: Get time when support hero take damage":
    @Event playerTookDamage
    @Condition eventPlayer.getCurrentHero() in ow1_support_heroes

    eventPlayer.last_time_damage_taken = getTotalTimeElapsed()
    eventPlayer.support_passive_active = false


rule "[no_support_passive.opy]: Check if support passive is active":
    @Event eachPlayer
    @Condition not eventPlayer.support_passive_active
    @Condition eventPlayer.getCurrentHero() in ow1_support_heroes
    @Condition getTotalTimeElapsed() - eventPlayer.last_time_damage_taken > OW1_ACTIVATION_TIME_PASSIVE_HEALING

    eventPlayer.support_passive_active = true
