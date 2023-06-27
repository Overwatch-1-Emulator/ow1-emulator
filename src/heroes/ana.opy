rule "Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.getCurrentHero() in getTankHeroes()
    
    waitUntil(victim.hasStatusEffect(Status.ASLEEP), 1)
    if victim.hasStatusEffect(Status.ASLEEP):
        victim.setStatusEffect(eventPlayer, Status.ASLEEP, 5/3.5*ow1_sleepdart_sleep_duration) # 5/3.5 is the ratio of regular sleep time to tank sleep time