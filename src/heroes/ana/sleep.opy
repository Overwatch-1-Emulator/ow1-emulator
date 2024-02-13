#!mainFile "../../main.opy"


rule "[ana/sleep.opy]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getCurrentHero() in getTankHeroes()
    
    waitUntil(victim.hasStatusEffect(Status.ASLEEP), Math.INFINITY)
    victim.setStatusEffect(attacker, Status.ASLEEP, Math.INFINITY)
    waitUntil(not victim.hasStatusEffect(Status.ASLEEP), OW1_ANA_SLEEP_DART_SLEEP_DURATION)
    victim.clearStatusEffect(Status.ASLEEP)
    victim.setMoveSpeed(100)
