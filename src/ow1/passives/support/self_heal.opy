#!mainFile "../../../main.opy"

playervar self_healing_source

playervar self_healing_percent
playervar self_healing_id
playervar support_passive_active
playervar last_time_damage_taken

subroutine removeSelfHealing
#!define pushSelfHealing(button) \
    eventPlayer.self_healing_source.append(button) \
    evalSelfHealingPercent()
#!define popSelfHealing(button) \
    eventPlayer.self_healing_source.remove(button) \
    evalSelfHealingPercent()
subroutine evalSelfHealingPercent


rule "[passives/support/self_heal.opy]: Remove support self healing passive":
    @Event eachPlayer
    @Condition eventPlayer.call_init == true
    @Condition eventPlayer.getCurrentHero() in getSupportHeroes()
    @Condition eventPlayer.getCurrentHero() not in [Hero.MERCY] # Exception to support healing passive

    removeSelfHealing()


rule "[passives/support/self_heal.opy]: Reset self healing":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    stopHealingModification(eventPlayer.self_healing_id)
    eventPlayer.self_healing_id = null
    eventPlayer.support_passive_active = true


def removeSelfHealing():
    @Name "[passives/support/self_heal.opy]: removeSelfHealing()"
    
    if eventPlayer.self_healing_id == null:
        startHealingModification(eventPlayer, eventPlayer, eventPlayer.self_healing_percent, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
        eventPlayer.self_healing_id = getLastHealingModification()
    eventPlayer.self_healing_source = []
    eventPlayer.self_healing_percent = 0

# Evaluates correct self healing percent from self_healing_source array
# f : x -> y
# x: array of currently active self-healing sources
# y: percent healing the player should receive given the self-healing sources
def evalSelfHealingPercent():
    @Name "[passives/support/self_heal.opy]: evalSelfHealingPercent()"

    # [TODO]: Derive more accurate formula
    # Currently sets self-heaing to 100% if there's any self healing source
    eventPlayer.self_healing_percent = 100 if len(eventPlayer.self_healing_source) > 0 else 0


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
