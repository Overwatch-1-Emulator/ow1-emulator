#!mainFile "../../dev_main.opy"

playervar defense_pvar
#!defineMember _defense_hp_id defense_pvar[0]
#!defineMember _last_defense_hp defense_pvar[1]
#!defineMember _new_defense_hp defense_pvar[2]

macro getOW1DefenseHp():
    eventPlayer.getHealthOfType(Health.SHIELDS)


macro getOW2DefenseHp():
    eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) - getOW1DefenseHp()


macro getTrueHp():
    eventPlayer.getHealth() - getOW2DefenseHp() - getOW1DefenseHp()


rule "[doomfist/defense.opy]: Remove OW2 best defense":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ULTIMATE]

    eventPlayer._last_defense_hp = getOW1DefenseHp()
    eventPlayer.setHealth(getTrueHp())


rule "[doomfist/defense.opy]: Remove OW2 best defense + add custom OW1 best defense":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ULTIMATE] \
            or eventPlayer.is_using_uppercut

    wait(0.25)
    # Add OW1 Best Defense.
    eventPlayer._new_defense_hp = min(eventPlayer._last_defense_hp + OW1_DOOMFIST_BEST_DEFENSE, OW1_DOOMFIST_BEST_DEFENSE_MAX)
    eventPlayer.addHealthPool(
        Health.SHIELDS,
        eventPlayer._new_defense_hp,
        false, false)
    # Unusused variable, but still good practice to remember most recent health pool.
    eventPlayer._defense_hp_id = getLastCreatedHealthPool()

    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER, Wait.RESTART_WHEN_TRUE)
    # decay Best Defense shields.
    while getOW1DefenseHp() > 0:
        damage(eventPlayer, null, 1)
        # Assume above code takes at least 1 tick to execute
        wait(1/OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE-TICK_DURATION, Wait.RESTART_WHEN_TRUE)
