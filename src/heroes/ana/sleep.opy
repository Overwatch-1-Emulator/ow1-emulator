#!mainFile "../../ow1pp_main.opy"


rule "[ana/sleep.opy]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getCurrentHero() in getTankHeroes()
    
    victim.setStatusEffect(null, Status.HACKED, 0.5)
    # immediately wake up victim
    waitUntil(victim.hasStatusEffect(Status.ASLEEP), Math.INFINITY)
    while (victim.hasStatusEffect(Status.ASLEEP)):
        wait(0.5)
        victim.clearStatusEffect(Status.ASLEEP)
    # resleep victim
    wait()
    victim.setStatusEffect(
        attacker, 
        Status.ASLEEP, 
        (OW1_ANA_SLEEP_DART_SLEEP_DURATION/OW2_ANA_SLEEP_DART_TANK_SLEEP_DURATION) * (OW1_ANA_SLEEP_DART_SLEEP_DURATION))
