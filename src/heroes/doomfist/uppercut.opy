#!mainFile "../../main.opy"

playervar uppercut_pvar
#!defineMember is_hit_by_uppercut uppercut_pvar[0]
#!defineMember is_uppercut_locked uppercut_pvar[1]
playervar uppercut_shields #uppercut_pvar[2]
#!defineMember hp_before_uppercut uppercut_pvar[3]
#!defineMember _uppercut_victims uppercut_pvar[4]
#!defineMember _uppercut_attacker uppercut_pvar[5]
#!defineMember _last_uppercut_attacker uppercut_pvar[6]


rule "[doomfist/uppercut.opy]: Control flow for uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isFiringSecondaryFire()

    eventPlayer.cancelPrimaryAction() # cancel Power Block animation
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)

    # Execute Uppercut
    eventPlayer.is_using_uppercut = true # Start of uppercut

    # Disable abilities during uppercut
    eventPlayer.is_uppercut_locked = true
    eventPlayer.setMeleeEnabled(false) # Doomfist cannot melee during uppercut
    eventPlayer.setPrimaryFireEnabled(false) # Doomfist cannot shoot during uppercut
    eventPlayer.setSecondaryFireEnabled(false) # Doomfist cannot punch during uppercut
    eventPlayer.setAbility1Enabled(false) # Doomfist cannot slam during uppercut
    eventPlayer.disallowButton(Button.ULTIMATE) # Doomfist cannot ult during uppercut
    wait(0.6)
    # Reenable abilities
    eventPlayer.is_uppercut_locked = false
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    if (eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)): # Shoot single buffered left click interrupted by power block
        eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.allowButton(Button.ULTIMATE)
    if (eventPlayer.isHoldingButton(Button.ULTIMATE)): # Activate ult if button held
        eventPlayer.forceButtonPress(Button.ULTIMATE)


rule "[doomfist/uppercut.opy]: Uppercut vfx + movement physics":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut

    # vfx
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)

    # movement physics
    cancelMomentum(eventPlayer)
    eventPlayer.disablePlayerCollision() # Doomfist phases through enemies during uppercut

    eventPlayer.applyImpulse(getForwardDirection(eventPlayer), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Step Forward
    eventPlayer.setGravity(0) # Override gravity during uppercut
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Deny player from inputting movement commands
    wait(0.15)
    eventPlayer.applyImpulse(Vector.UP, 40, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Uppercut
    wait(0.1)
    eventPlayer.applyImpulse(Vector.DOWN, max(0, eventPlayer.getSpeedInDirection(Vector.UP)), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait()
    eventPlayer.applyImpulse(Vector.UP, 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.enablePlayerCollision()
    wait(0.35)

    eventPlayer.is_using_uppercut = false # End of uppercut

    # set cooldown
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_UPPERCUT_COOLDOWN)
    eventPlayer.setAbility2Enabled(true)

    eventPlayer.stopForcingThrottle()
    wait(0.15)
    if (eventPlayer.isUsingAbility1()): return
    eventPlayer.setGravity(50)
    wait(0.25)
    if (eventPlayer.isUsingAbility1()): return
    eventPlayer.setGravity(100)


rule "[doomfist/uppercut.opy]: Detect uppercut victims":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut
    @Condition eventPlayer.isAlive()

    do:
        eventPlayer._uppercut_victims = \
            getPlayersInRadius(
                eventPlayer, 
                OW1_DOOMFIST_RISING_UPPERCUT_RADIUS, 
                getOppositeTeam(eventPlayer.getTeam()), 
                LosCheck.SURFACES)
        eventPlayer._uppercut_victims = \
            [uppercut_victim for uppercut_victim in eventPlayer._uppercut_victims 
                    if ((uppercut_victim.isAlive()) \
                    and (angleBetweenVectors(
                            getForwardDirection(eventPlayer), 
                                directionTowards(
                                    eventPlayer, 
                                    uppercut_victim)) 
                        <= 90))] # Victim in front of doomfist

        eventPlayer._uppercut_victims.is_hit_by_uppercut = true
        eventPlayer._uppercut_victims._uppercut_attacker = eventPlayer

        wait()
    while RULE_CONDITION


rule "[doomfist/uppercut.opy]: Damage uppercut victims + vfx + uppercut knockback physics":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut
    @Condition eventPlayer._last_uppercut_attacker != eventPlayer._uppercut_attacker

    # damage
    damage(eventPlayer, eventPlayer._uppercut_attacker, OW1_DOOMFIST_RISING_UPPERCUT_DAMAGE)
    eventPlayer.setEnvironmentalKillCreditor(eventPlayer._uppercut_attacker)

    # upercut hit vfx
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer, 1)

    # knockback
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Lose movement control
    eventPlayer.applyImpulse(Vector.UP, 13.5, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(getForwardDirection(eventPlayer._uppercut_attacker), 8.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(OW1_DOOMFIST_RISING_UPPERCUT_AIR_LOCK_TIME)
    eventPlayer.stopForcingThrottle() # Regain movement control


rule "[doomfist/uppercut.opy]: Best defense for each uppercut victim hit":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut
    @Condition eventPlayer._last_uppercut_attacker != eventPlayer._uppercut_attacker

    # best defense
    stopChasingVariable(eventPlayer._uppercut_attacker.uppercut_shields)
    eventPlayer._uppercut_attacker.uppercut_shields += OW1_DOOMFIST_BEST_DEFENSE
    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)
    chase(eventPlayer._uppercut_attacker.uppercut_shields, 0, rate=OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE, ChaseReeval.NONE)


rule "[doomfist/uppercut.opy]: Uppercut victim state variables":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut
    @Condition eventPlayer._last_uppercut_attacker != eventPlayer._uppercut_attacker

    eventPlayer._last_uppercut_attacker = eventPlayer._uppercut_attacker
    waitUntil(not eventPlayer._uppercut_attacker.is_using_uppercut, Math.INFINITY)
    eventPlayer.is_hit_by_uppercut = false
    eventPlayer._uppercut_attacker = null
    eventPlayer._last_uppercut_attacker = null


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
