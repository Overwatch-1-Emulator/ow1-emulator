#!mainFile "../../main.opy"


def healPassiveReset():
    @Name "[passive/support/self_heal.opy]: healPassiveReset()"
    
    damage(eventPlayer, null, 0.001 / 1000)
    heal(eventPlayer, null, 0.001 / 1000)


rule "[passive/support/self_heal.opy]: When to stop self-heal":
    @Event eachPlayer
    @Condition eventPlayer.isInSpawnRoom() == false
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) == eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth()
    @Condition eventPlayer.heal_state != 0
    
    healPassiveReset()
    wait(2.484 if eventPlayer.getCurrentHero() in getSupportHeroes() else 4.984, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START