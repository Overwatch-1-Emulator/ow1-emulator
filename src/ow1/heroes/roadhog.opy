#!mainFile "../../main.opy"

subroutine initRoadhog
playervar time_hook_was_active

rule "[roadhog.opy]: Initialize Roadhog":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait()
    setCustomHealth(OW1_ROADHOG_HEALTH, 0, 0)

    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE)

    eventPlayer.setDamageDealt(percent(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE))
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))


rule "[roadhog.opy]: Set default hook cooldown":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.time_hook_was_active = 0
    chase(eventPlayer.time_hook_was_active, 3, rate=1, ChaseReeval.NONE)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_ROADHOG_HOOK_COOLDOWN_TIME - eventPlayer.time_hook_was_active)


rule "[roadhog.opy]: Disable all abilities during ult":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)


rule "[roadhog.opy]: Force autofire during ult":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "[roadhog.opy]: Stop autofire when not in ult":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[roadhog.opy]: Cancel ult when stunned":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) or eventPlayer.hasStatusEffect(Status.FROZEN) or eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) or eventPlayer.hasStatusEffect(Status.ASLEEP) or eventPlayer.hasStatusEffect(Status.STUNNED)

    if eventPlayer.hasStatusEffect(Status.HACKED):
        #waitUntil(eventPlayer.hasStatusEffect(Status.HACKED) == false, 9999) if hacked, instantly cancel ult
    elif eventPlayer.hasStatusEffect(Status.FROZEN):
        waitUntil(eventPlayer.hasStatusEffect(Status.FROZEN) == false, 9999)
    elif eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN):
        waitUntil(eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false, 9999)
    elif eventPlayer.hasStatusEffect(Status.ASLEEP):
        waitUntil(eventPlayer.hasStatusEffect(Status.ASLEEP) == false, 9999)
    elif eventPlayer.hasStatusEffect(Status.STUNNED):
        waitUntil(eventPlayer.hasStatusEffect(Status.STUNNED) == false, 9999)
    
    if eventPlayer.isUsingUltimate() == true:
        respawnSameState()


rule "[roadhog.opy]: Move hooked enemies closer":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility1() == true

    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    if distance(victim, attacker) <= OW2_ROADHOG_HOOK_PROXIMITY + 0.5:
        victim.teleport(raycast(victim.getPosition(), 
                        victim.getPosition() + (OW2_ROADHOG_HOOK_PROXIMITY - OW1_ROADHOG_HOOK_PROXIMITY)*directionTowards(victim, attacker), 
                        null, 
                        null, 
                        false).getHitPosition()) 


rule "[roadhog.opy]: Reduce ultimate duration":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate() == true
    
    wait(OW1_ROADHOG_ULTIMATE_DURATION)
    # Check if the ultimate was not cancelled before
    if eventPlayer.isUsingUltimate():
        respawnSameState()
    

