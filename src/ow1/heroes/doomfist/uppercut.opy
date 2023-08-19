#!mainFile "../../../main.opy"

playervar e_pressed_by_bot

playervar pressing_uppercut_key
playervar is_hit_by_uppercut

subroutine executeUppercut
subroutine detectUpercutHit

rule "[uppercut.opy]: Detect e key press by human":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.e_pressed_by_bot == false

    eventPlayer.pressing_uppercut_key = true
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_2), 9999)
    eventPlayer.pressing_uppercut_key = false


rule "[uppercut.opy]: Control flow for uppercut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.pressing_uppercut_key == true
    @Condition eventPlayer.is_using_slam == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    # @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Doomfist is not hacked
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN) # Ensure Doomfist is not frozen
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) # Ensure Doomfist is not knocked down
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP) # Ensure Doomfist is not asleep
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED) # Ensure Doomfist is not stunned

    executeUppercut()


def executeUppercut():
    @Name "[uppercut.opy]: executeUppercut()"

    eventPlayer.disablePlayerCollision() # Doomfist phases through enemies during uppercut

    # Uppercut physics
    eventPlayer.is_using_uppercut = true # Start of uppercut
    eventPlayer.applyImpulse(eventPlayer.getVelocity(), -eventPlayer.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Cancel current momentum
    eventPlayer.applyImpulse(getLateralFacingDirection(eventPlayer), 5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Step Forward
    eventPlayer.setGravity(0) # Override gravity during uppercut
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Deny player from inputting movement commands
    wait(0.15)
    eventPlayer.applyImpulse(Vector.UP, 40, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION) # Uppercut
    wait(0.1)
    eventPlayer.applyImpulse(Vector.DOWN, max(0, eventPlayer.getSpeedInDirection(Vector.UP)), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.is_using_uppercut = false # End of uppercut
    wait()
    eventPlayer.applyImpulse(Vector.UP, 2.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    eventPlayer.enablePlayerCollision()
    wait(0.35)
    eventPlayer.stopForcingThrottle()
    wait(0.15)
    eventPlayer.setGravity(50)
    wait(0.25)
    eventPlayer.setGravity(100)


rule "[uppercut.opy]: Play uppercut VFX":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut == true

    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, eventPlayer.getTeam(), eventPlayer, 100)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, eventPlayer.getTeam(), eventPlayer, 100)


rule "[uppercut.opy]: Set uppercut cooldown":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut == true

    waitUntil(eventPlayer.is_using_uppercut == false, 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_DOOMFIST_RISING_UPPERCUT_COOLDOWN_TIME)


rule "[uppercut.opy]: Disable abilities when uppercutting":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.is_using_uppercut == true
    
    eventPlayer.setMeleeEnabled(false) # Doomfist cannot melee during uppercut
    eventPlayer.setPrimaryFireEnabled(false) # Doomfist cannot shoot during uppercut
    eventPlayer.setSecondaryFireEnabled(false) # Doomfist cannot punch during uppercut
    waitUntil(eventPlayer.is_using_uppercut == false, 9999)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)


rule "[uppercut.opy]: Detect uppercut victims":
    @Event eachPlayer
    @Condition eventPlayer.enemy_doomfist_player.is_using_uppercut == true # Enemy doomfist using uppercut
    @Condition distance(eventPlayer.enemy_doomfist_player, eventPlayer) <= OW1_DOOMFIST_RISING_UPPERCUT_RADIUS # Victim within uppercut hitbox range
    @Condition isInLoS(eventPlayer.enemy_doomfist_player, eventPlayer, BarrierLos.PASS_THROUGH_BARRIERS) # Victim in los of doomfist
    @Condition angleBetweenVectors(getLateralFacingDirection(eventPlayer.enemy_doomfist_player), \
                                   directionTowards(eventPlayer.enemy_doomfist_player, eventPlayer)) <= 90 # Victim visible to doomfist
    @Condition eventPlayer.enemy_doomfist_player.isAlive() == true # Enemy doomfist alive
    @Condition eventPlayer.isAlive() == true # Victim is alive

    eventPlayer.is_hit_by_uppercut = true


rule "[uppercut.opy]: Uppercut victim movement physics":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0) # Lose movement control
    eventPlayer.applyImpulse(Vector.UP, 13.5, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(getLateralFacingDirection(eventPlayer.enemy_doomfist_player), 8.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(OW1_DOOMFIST_RISING_UPPERCUT_AIR_LOCK_TIME)
    eventPlayer.stopForcingThrottle() # Regain movement control
    eventPlayer.is_hit_by_uppercut = false


rule "[uppercut.opy]: Damage uppercut victims":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    damage(eventPlayer, eventPlayer.enemy_doomfist_player, OW1_DOOMFIST_RISING_UPPERCUT_DAMAGE)
    eventPlayer.setEnvironmentalKillCreditor(eventPlayer.enemy_doomfist_player)


rule "[uppercut.opy]: Play uppercut hit VFX":
    @Event eachPlayer
    @Condition eventPlayer.is_hit_by_uppercut == true

    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer, 1)