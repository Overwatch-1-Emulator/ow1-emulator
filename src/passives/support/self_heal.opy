#!mainFile "../../dev_main.opy"

playervar self_heal_pvar
#!defineMember _self_healing_source self_heal_pvar[0]
#!defineMember _self_healing_percent self_heal_pvar[1]
#!defineMember _self_healing_id self_heal_pvar[2]
#!defineMember _passive_healing_active self_heal_pvar[3]
#!defineMember _last_time_damage_taken self_heal_pvar[4]
#!defineMember _suppress_passive_healing self_heal_pvar[5]

#!define resetSelfHealing()\
    stopHealingModification(eventPlayer._self_healing_id)\
    eventPlayer._self_healing_id = null\
    eventPlayer._self_healing_source = []\
    eventPlayer._self_healing_percent = 0\
    eventPlayer._passive_healing_active = true\
    eventPlayer._suppress_passive_healing = false\

#!define removePassiveHealing()\
    eventPlayer._suppress_passive_healing = true

#!define removeSelfHealing()\
    eventPlayer._self_healing_source = []\
    eventPlayer._self_healing_percent = 0\
    if eventPlayer._self_healing_id == null:\
        startHealingModification(eventPlayer, eventPlayer, eventPlayer._self_healing_percent, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)\
        eventPlayer._self_healing_id = getLastHealingModification()

# Evaluates correct self healing percent from _self_healing_source array
# f : x -> y
# x: array of currently active self-healing sources
# y: percent healing the player should receive given the self-healing sources
# [TODO]: Derive more accurate formula
# Currently sets self-heaing to 100% if there's any self healing source
#!define evalSelfHealingPercent()\
    eventPlayer._self_healing_percent = 100 if len(eventPlayer._self_healing_source) > 0 else 0\
    eventPlayer._suppress_passive_healing = true if eventPlayer._self_healing_percent > 0 else false

#!define pushSelfHealing(button) \
    if (button not in eventPlayer._self_healing_source): \
        eventPlayer._self_healing_source.append(button) \
evalSelfHealingPercent()

#!define popSelfHealing(button) \
    eventPlayer._self_healing_source.remove(button) \
    evalSelfHealingPercent()


rule "[passives/support/self_heal.opy]: Detect healing passive":
    @Event playerTookDamage

    eventPlayer._passive_healing_active = false
    if eventPlayer.getCurrentHero() in getSupportHeroes(): # supports
        wait(OW2_SUPPORT_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION)
    else: # all other roles
        wait(OW2_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION)
    eventPlayer._passive_healing_active = true


# Deal damage to suppress passive self healing except when regenerating shield hp
rule "[passives/support/self_heal.opy]: Remove Passive self healing":
    @Event eachPlayer
    @Condition eventPlayer._suppress_passive_healing
    @Condition eventPlayer._passive_healing_active
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) >= eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP)
    
    do:
        damage(eventPlayer, null, MIN_DAMAGE)
        wait(OW2_SUPPORT_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION \
            if eventPlayer.getCurrentHero() in getSupportHeroes() \
            else OW2_HEAL_PASSIVE_ACTIVATION_TIME - TICK_DURATION, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION
