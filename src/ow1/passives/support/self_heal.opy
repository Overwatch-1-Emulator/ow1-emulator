#!mainFile "../../../main.opy"

playervar self_healing_percent
playervar self_healing_modification
playervar support_passive_active
playervar last_time_damage_taken

subroutine removeSelfHealing


rule "[passives/support/self_heal.opy]: Remove support self healing passive":
    @Event eachPlayer
    @Condition eventPlayer.call_init == true
    @Condition eventPlayer.getCurrentHero() in getSupportHeroes()
    @Condition eventPlayer.getCurrentHero() not in [Hero.MERCY] # Exception to support healing passive

    removeSelfHealing()


rule "[passives/support/self_heal.opy]: Reset self healing":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    stopHealingModification(eventPlayer.self_healing_modification)
    eventPlayer.support_passive_active = true


def removeSelfHealing():
    @Name "[passives/support/self_heal.opy]: removeSelfHealing()"
    
    stopHealingModification(eventPlayer.self_healing_modification)
    eventPlayer.self_healing_percent = 0
    startHealingModification(eventPlayer, eventPlayer, eventPlayer.self_healing_percent, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.self_healing_modification = getLastHealingModification()


rule "[passives/support/self_heal.opy]: Get time when support hero take damage":
    @Event playerTookDamage
    @Condition eventPlayer.getCurrentHero() in support_heroes

    eventPlayer.last_time_damage_taken = getTotalTimeElapsed()
    eventPlayer.support_passive_active = false


rule "[passives/support/self_heal.opy]: Check if support passive is active":
    @Event eachPlayer
    @Condition not eventPlayer.support_passive_active
    @Condition eventPlayer.getCurrentHero() in support_heroes
    @Condition getTotalTimeElapsed() - eventPlayer.last_time_damage_taken > OW1_ACTIVATION_TIME_PASSIVE_HEALING

    eventPlayer.support_passive_active = true
