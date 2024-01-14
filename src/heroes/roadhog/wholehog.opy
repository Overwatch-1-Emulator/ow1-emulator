#!mainFile "../../main.opy"


rule "[roadhog/wholehog.opy]: OW1 Wholehog disable abilities":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[roadhog/wholehog.opy]: OW1 Wholehog force autofire":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "[roadhog/wholehog.opy]: Cancel ult when stunned":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) \
            or eventPlayer.hasStatusEffect(Status.FROZEN) \
            or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) \
            or eventPlayer.hasStatusEffect(Status.ASLEEP) \
            or eventPlayer.hasStatusEffect(Status.STUNNED)

    if eventPlayer.hasStatusEffect(Status.HACKED):
        #waitUntil(eventPlayer.hasStatusEffect(Status.HACKED) == false, Math.INFINITY) if hacked, instantly cancel ult
    elif eventPlayer.hasStatusEffect(Status.FROZEN):
        waitUntil(not eventPlayer.hasStatusEffect(Status.FROZEN), Math.INFINITY)
    elif eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN):
        waitUntil(not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN), Math.INFINITY)
    elif eventPlayer.hasStatusEffect(Status.ASLEEP):
        waitUntil(not eventPlayer.hasStatusEffect(Status.ASLEEP), Math.INFINITY)
    elif eventPlayer.hasStatusEffect(Status.STUNNED):
        waitUntil(not eventPlayer.hasStatusEffect(Status.STUNNED), Math.INFINITY)
    
    if eventPlayer.isUsingUltimate():
        respawnSameState()


rule "[roadhog/wholehog.opy]: Reduce ultimate duration":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    
    wait(OW1_ROADHOG_ULTIMATE_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    respawnSameState()
