rule "Sleep tanks for longer duration":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in getTankHeroes()
    @Condition eventPlayer.hasStatusEffect(Status.ASLEEP)
    
    eventPlayer.setStatusEffect(null, Status.ASLEEP, 5/3.25*ow1_sleepdart_sleep_duration) # 5/3.5 is the ratio of regular sleep time to tank sleep time