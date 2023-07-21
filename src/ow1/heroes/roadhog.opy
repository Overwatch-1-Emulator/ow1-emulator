#!mainFile "../../main.opy"

subroutine initRoadhog
playervar time_hook_was_active 0

rule "[roadhog.opy]: Detect Roadhog initialization":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initRoadhog()
    eventPlayer.initialized = true


def initRoadhog():
    @Name "[roadhog.opy]: initRoadhog()"
    
    do:
        clearCustomHealth()
        setCustomHealth(OW1_ROADHOG_HEALTH, 0, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_ROADHOG_HEALTH)

    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE)

    eventPlayer.setDamageDealt(percent(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE))


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


rule "[roadhog.opy]: Move hooked enemies closer":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility1() == true

    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    victim.applyImpulse(directionTowards(victim, attacker), 25*(OW2_ROADHOG_HOOK_PROXIMITY-OW1_ROADHOG_HOOK_PROXIMITY), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
