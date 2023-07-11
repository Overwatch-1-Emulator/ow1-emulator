#!mainFile "../../main.opy"

# effect to show players that received the HoT
#!define playRegenBurstHoTEffect(h) playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, h, 1)

playervar regen_burst_targets # stores players affected by Baptiste's regen burst.
playervar exo_boots_charge_normalized # value from 0 to 1
playervar exo_boots_charge_hud_visible

subroutine initBaptiste

rule "[baptiste.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initBaptiste()
    eventPlayer.initialized = true

def initBaptiste():
    @Name "[baptiste.opy]: initBaptiste()"
    
    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

    eventPlayer.disallowButton(Button.ABILITY_1)

    eventPlayer.exo_boots_charge_hud_visible = false
    # initialize exo boots charge bar
    progressBarHud(eventPlayer.exo_boots_charge_hud_visible, percent(eventPlayer.exo_boots_charge_normalized),
    null, HudPosition.TOP, 1, Color.SKY_BLUE, null, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.NEVER)
    eventPlayer.progress_bar_huds.append(getLastCreatedText())

rule "[baptiste.opy]: Set default immortality field cooldown":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_BAPTISTE_IMMORTALITY_COOLDOWN)

rule "[baptiste.opy]: Start charging exo boots":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isCrouching()

    # waiting here makes it so spam-crouching doesn't cause this to break
    wait()
    eventPlayer.exo_boots_charge_hud_visible = true
    # don't allow the player to jump normally, because that would use the OW2 exo boots which charge faster
    eventPlayer.setJumpEnabled(false)
    chase(eventPlayer.exo_boots_charge_normalized, 1, duration=OW1_BAPTISTE_EXO_BOOTS_CHARGE_TIME, ChaseReeval.NONE)

rule "[baptiste.opy]: Handle exo boots charge reset":
    @Event eachPlayer
    @Hero baptiste
    @Condition not eventPlayer.isCrouching()
    @Condition eventPlayer.exo_boots_charge_normalized > 0

    # stop charging exo boots
    stopChasingVariable(eventPlayer.exo_boots_charge_normalized)
    # if the player crouches again, or jumps, or the linger time runs out, the exo boots charge goes back to 0
    waitUntil(eventPlayer.isCrouching() or (eventPlayer.isOnGround() and eventPlayer.isHoldingButton(Button.JUMP)), OW1_BAPTISTE_EXO_BOOTS_LINGER_DURATION)
    eventPlayer.exo_boots_charge_hud_visible = false
    # another grace period in case the player chose to jump, so we can use the value of exo_boots_charge_normalized for that
    wait()
    eventPlayer.exo_boots_charge_normalized = 0
    eventPlayer.setJumpEnabled(true)


rule "[baptiste.opy]: Handle exo boots jump":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    @Condition eventPlayer.isOnGround()
    @Condition eventPlayer.exo_boots_charge_normalized > 0
    @Condition eventPlayer.isAlive()
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP)
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN)
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN)
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED)

    eventPlayer.applyImpulse(Vector.UP, 
    OW1_BAPTISTE_EXO_BOOTS_MIN_JUMP_SPEED + eventPlayer.exo_boots_charge_normalized * (OW1_BAPTISTE_EXO_BOOTS_MAX_JUMP_SPEED - OW1_BAPTISTE_EXO_BOOTS_MIN_JUMP_SPEED),
    Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "[baptiste.opy]: Use OW1 regenerative burst":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isAlive()
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP)
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN)
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN)
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED)

    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_BAPTISTE_REGEN_BURST_COOLDOWN)

    # custom effect to indicate Baptiste used regen burst
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.YELLOW, eventPlayer, OW1_BAPTISTE_REGEN_BURST_RADIUS)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 100) # 100% volume

    # find allies within regen burst range, excluding baptiste himself
    eventPlayer.regen_burst_targets = [
        p for p in getPlayersInRadius(eventPlayer.getPosition(), OW1_BAPTISTE_REGEN_BURST_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES_AND_ENEMY_BARRIERS)
        if p != eventPlayer
    ]

    # baptiste heals more from his own regen burst than allies, so we handle him separately
    eventPlayer.startHoT(eventPlayer, OW1_BAPTISTE_REGEN_BURST_DURATION, OW1_BAPTISTE_REGEN_BURST_SELF_HPS)
    playRegenBurstHoTEffect(eventPlayer)

    for i in range(len(eventPlayer.regen_burst_targets)):
        eventPlayer.regen_burst_targets[i].startHoT(eventPlayer, OW1_BAPTISTE_REGEN_BURST_DURATION, OW1_BAPTISTE_REGEN_BURST_ALLY_HPS)
        playRegenBurstHoTEffect(eventPlayer.regen_burst_targets[i])


rule "[baptiste.opy]: Reset values on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true
    @Condition eventPlayer.getCurrentHero() != Hero.BAPTISTE

    # fixes situation where it indefinitely disables jumping if you swap heroes within 1 second of crouching
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setCrouchEnabled(true)
    eventPlayer.exo_boots_charge_normalized = 0
    eventPlayer.exo_boots_charge_hud_visible = false

    eventPlayer.regen_burst_targets = []
