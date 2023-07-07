#!mainFile "../../main.opy"

playervar regen_burst_cooldown 
playervar regen_burst_targets # stores players affected by Baptiste's regen burst.

def initBaptiste():
    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

    eventPlayer.setAbility1Enabled(false)

rule "[baptiste.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initBaptiste()
    eventPlayer.initialized = true

rule "[baptiste.opy]: Set default immortality field cooldown":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_BAPTISTE_IMMORTALITY_COOLDOWN)

rule "[baptiste.opy]: Use OW1 regenerative burst":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.regen_burst_cooldown == 0
    @Condition eventPlayer.isAlive()
    # @Condition is not stunned slept etc

    eventPlayer.regen_burst_cooldown = 5
    eventPlayer.regen_burst_targets = getPlayersInRadius(eventPlayer.getPosition(), OW1_BAPTISTE_REGEN_BURST_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
    for i in range(len(eventPlayer.regen_burst_targets)):
        if eventPlayer.regen_burst_targets[i] != eventPlayer:
            eventPlayer.regen_burst_targets[i].startHoT(eventPlayer, OW1_BAPTISTE_REGEN_BURST_DURATION, 10)
        else:
            eventPlayer.regen_burst_targets[i].startHoT(eventPlayer, OW1_BAPTISTE_REGEN_BURST_DURATION, 10)
    chase(eventPlayer.regen_burst_cooldown, 0, rate=1, ChaseReeval.NONE)
