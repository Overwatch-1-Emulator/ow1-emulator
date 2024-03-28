#!mainFile "../../dev_main.opy"

playervar is_hit_by_uppercut
playervar is_uppercut_locked
playervar uppercut_shields
playervar hp_before_uppercut

subroutine executeUppercut


rule "[doomfist/uppercut.opy]: Control flow for uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isFiringSecondaryFire()

    eventPlayer.cancelPrimaryAction() # cancel Power Block animation
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    executeUppercut()


def executeUppercut():
    @Name "[doomfist/uppercut.opy]: executeUppercut()"

    eventPlayer.is_using_uppercut = true # Start of uppercut
    
    cancelMomentum(eventPlayer)
    eventPlayer.disablePlayerCollision() # Doomfist phases through enemies during uppercut
    
    # Disable abilities during uppercut
    eventPlayer.is_uppercut_locked = true

    # Uppercut physics
    eventPlayer.applyImpulse(getForwardDirection(eventPlayer), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Step Forward
    eventPlayer.setGravity(0) # Override gravity during uppercut
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Deny player from inputting movement commands
    wait(0.15)
    eventPlayer.applyImpulse(Vector.UP, 40, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Uppercut
    wait(0.1)
    eventPlayer.applyImpulse(Vector.DOWN, max(0, eventPlayer.getSpeedInDirection(Vector.UP)), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    
    # Reenable abilities
    eventPlayer.is_uppercut_locked = false

    wait()
    eventPlayer.applyImpulse(Vector.UP, 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.enablePlayerCollision()
    wait(0.35)
    eventPlayer.is_using_uppercut = false # End of uppercut
    eventPlayer.stopForcingThrottle()
    wait(0.15)
    if (eventPlayer.isUsingAbility1()): return
    eventPlayer.setGravity(50)
    wait(0.25)
    if (eventPlayer.isUsingAbility1()): return
    eventPlayer.setGravity(100)


rule "[doomfist/uppercut.opy]: Disable abilities when locked into uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_uppercut_locked
    
    eventPlayer.is_uppercut_locked = true
    eventPlayer.setMeleeEnabled(false) # Doomfist cannot melee during uppercut
    eventPlayer.setPrimaryFireEnabled(false) # Doomfist cannot shoot during uppercut
    eventPlayer.setSecondaryFireEnabled(false) # Doomfist cannot punch during uppercut
    eventPlayer.setAbility1Enabled(false) # Doomfist cannot slam during uppercut
    waitUntil(not eventPlayer.is_uppercut_locked, Math.INFINITY)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    if (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)): # Shoot single buffered left click interrupted by power block
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)


rule "[doomfist/uppercut.opy]: Play uppercut VFX":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut

    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)


rule "[doomfist/uppercut.opy]: Set uppercut cooldown":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut

    waitUntil(not eventPlayer.is_using_uppercut, Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_UPPERCUT_CD)
    eventPlayer.setAbility2Enabled(true)


rule "[doomfist/uppercut.opy]: Detect uppercut victims":
    @Event eachPlayer
    @Condition eventPlayer.enemy_doomfist_player.is_using_uppercut
    @Condition distance(eventPlayer.enemy_doomfist_player, eventPlayer) <= OW1_DOOMFIST_RISING_UPPERCUT_RADIUS # Victim within uppercut hitbox range
    @Condition isInLoS(eventPlayer.enemy_doomfist_player, eventPlayer, BarrierLos.PASS_THROUGH_BARRIERS) # Victim in los of doomfist
    @Condition angleBetweenVectors(worldVector(Vector.FORWARD, eventPlayer.enemy_doomfist_player, Transform.ROTATION), \
                                   directionTowards(eventPlayer.enemy_doomfist_player, eventPlayer)) <= 90 # Victim in front of doomfist
    @Condition eventPlayer.enemy_doomfist_player.isAlive() # attacker alive
    @Condition eventPlayer.isAlive() # victim alive

    eventPlayer.is_hit_by_uppercut = true

    stopChasingVariable(eventPlayer.enemy_doomfist_player.uppercut_shields)
    eventPlayer.enemy_doomfist_player.uppercut_shields += OW1_DOOMFIST_BEST_DEFENSE
    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)
    chase(eventPlayer.enemy_doomfist_player.uppercut_shields, 0, rate=OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE, ChaseReeval.NONE)


rule "[doomfist/uppercut.opy]: Uppercut victim movement physics":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Lose movement control
    eventPlayer.applyImpulse(Vector.UP, 13.5, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(getForwardDirection(eventPlayer.enemy_doomfist_player), 8.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(OW1_DOOMFIST_RISING_UPPERCUT_AIR_LOCK_TIME)
    eventPlayer.stopForcingThrottle() # Regain movement control
    eventPlayer.is_hit_by_uppercut = false


rule "[doomfist/uppercut.opy]: Damage uppercut victims":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    damage(eventPlayer, eventPlayer.enemy_doomfist_player, OW1_DOOMFIST_RISING_UPPERCUT_DAMAGE)
    eventPlayer.setEnvironmentalKillCreditor(eventPlayer.enemy_doomfist_player)


rule "[doomfist/uppercut.opy]: Play uppercut hit VFX":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer, 1)


rule "[doomfist/uppercut.opy]: Heal doomfist uppercut shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition updateEveryTick(eventPlayer.uppercut_shields > 0)
    @Condition updateEveryTick(eventPlayer.getHealth() < eventPlayer.getMaxHealth())
    
    do:
        eventPlayer.hp_before_uppercut = eventPlayer.getHealth()
        heal(eventPlayer, null, eventPlayer.uppercut_shields)
        eventPlayer.uppercut_shields -= min(eventPlayer.getMaxHealth() - eventPlayer.hp_before_uppercut, eventPlayer.uppercut_shields)
        wait()
    while RULE_CONDITION
