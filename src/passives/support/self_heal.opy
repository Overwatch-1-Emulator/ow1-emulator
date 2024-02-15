#!mainFile "../../main.opy"

playervar self_heal_pvar
#!defineMember self_healing_source self_heal_pvar[0]
#!defineMember self_healing_percent self_heal_pvar[1]
#!defineMember self_healing_id self_heal_pvar[2]
#!defineMember _passive_healing_active self_heal_pvar[3]
#!defineMember last_time_damage_taken self_heal_pvar[4]

subroutine resetSelfHealing
subroutine removeSelfHealing
subroutine evalSelfHealingPercent

#!define pushSelfHealing(button) \
    if (button not in eventPlayer.self_healing_source): \
        eventPlayer.self_healing_source.append(button) \
evalSelfHealingPercent()

#!define popSelfHealing(button) \
    eventPlayer.self_healing_source.remove(button) \
    evalSelfHealingPercent()


def resetSelfHealing():
    @Name "[passives/support/self_heal.opy]: resetSelfHealing()"

    stopHealingModification(eventPlayer.self_healing_id)
    eventPlayer.self_healing_id = null
    eventPlayer.self_healing_source = []
    eventPlayer.self_healing_percent = 0
    eventPlayer._passive_healing_active = true


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
    @Condition eventPlayer.getCurrentHero() in getSupportHeroes()

    eventPlayer._passive_healing_active = false
    wait(OW2_SUPPORT_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION)
    eventPlayer._passive_healing_active = true


rule "[passives/support/self_heal.opy]: Get time when non-support hero take damage":
    @Event playerTookDamage
    @Condition eventPlayer.getCurrentHero() not in getSupportHeroes()

    eventPlayer._passive_healing_active = false
    wait(OW2_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION)
    eventPlayer._passive_healing_active = true


rule "[passives/support/self_heal.opy]: Deal damage to suppress self healing except when regenerating shield hp":
    @Event eachPlayer
    @Condition eventPlayer._passive_healing_active
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) >= eventPlayer.hp_shields
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    @Condition eventPlayer.self_healing_id != null
    
    do:
        damage(eventPlayer, null, MIN_DAMAGE)
        wait(OW2_SUPPORT_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION \
             if eventPlayer.getCurrentHero() in getSupportHeroes() \
             else OW2_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION
