#!mainFile "../../main.opy"

#!define MIN_SLEEP_DURATION 0.5

playervar sleep_pvar
#!defineMember _tank_sleep_start_time sleep_pvar[0]
#!defineMember _tank_sleeping sleep_pvar[1]

#!define using_knockdown(eventPlayer, eventAbility)\
    (((eventPlayer.getCurrentHero() == Hero.SIGMA) and (eventAbility == Button.ABILITY_2))\
  or ((eventPlayer.getCurrentHero() == Hero.REINHARDT) and (eventAbility == Button.ULTIMATE)))


rule "[ana/sleep.opy]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getCurrentHero() in getTankHeroes()
    
    victim._tank_sleep_start_time = getTotalTimeElapsed()
    waitUntil(victim.hasStatusEffect(Status.ASLEEP), Math.INFINITY)
    victim._tank_sleeping = true
    wait(MIN_SLEEP_DURATION)
    victim.clearStatusEffect(Status.ASLEEP)
    victim.setStatusEffect(null, Status.KNOCKED_DOWN, OW1_ANA_SLEEP_DART_SLEEP_DURATION-MIN_SLEEP_DURATION)
    wait(OW1_ANA_SLEEP_DART_SLEEP_DURATION-MIN_SLEEP_DURATION)
    victim._tank_sleeping = false


rule "[ana/sleep.opy]: Wake sleeping tank if damage taken after MIN_SLEEP_DURATION":
    @Event playerTookDamage
    @Condition victim._tank_sleeping
    @Condition not victim.hasStatusEffect(Status.ASLEEP)
    @Condition victim.getCurrentHero() in getTankHeroes()
    @Condition getTotalTimeElapsed() - victim._tank_sleep_start_time > MIN_SLEEP_DURATION
    @Condition not using_knockdown(attacker, eventAbility)

    victim.clearStatusEffect(Status.KNOCKED_DOWN)
    eventPlayer._tank_sleeping = false
