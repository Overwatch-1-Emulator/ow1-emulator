#!mainFile "../main.opy"

# Credit to https://discord.com/channels/570672959799164958/1095384108504465488
# Base code written by CaptCaptain
playervar health_normal
playervar health_armor
playervar health_shields

#!define setCustomHealth(hp_health, hp_armor, hp_shields)\
    eventPlayer.health_normal = hp_health\
    eventPlayer.health_armor = hp_armor\
    eventPlayer.health_shields = hp_shields\
    applyCustomHealth()
#!define isHero(player, hero) (player.getCurrentHero() == hero or player.getHeroOfDuplication() == hero)

playervar storedSpawnPosition

subroutine clearCustomHealth
subroutine applyCustomHealth


rule "[custom_health_handler.opy]: Reset hp":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    clearCustomHealth()


def clearCustomHealth():
    @Name "[custom_health_handler.opy]: clearCustomHealth()"

    eventPlayer.removeAllHealthPools()
    wait()
    eventPlayer.setMaxHealth(100.001)
    wait()
    eventPlayer.setMaxHealth(100)
    heal(eventPlayer, null, Math.INFINITY)


def applyCustomHealth():
    @Name "[custom_health_handler.opy]: applyCustomHealth()"
    
    # If the player is in spawn, teleport them out as they are invulnerable in spawn
    if eventPlayer.isInSpawnRoom():
        eventPlayer.startCamera(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection(), 0.001)
        wait(0.032)
        eventPlayer.storedSpawnPosition = eventPlayer.getPosition()
        eventPlayer.teleport(eventPlayer.getPosition() + vect(0, 100, 0))
        waitUntil(not eventPlayer.isInSpawnRoom() and not eventPlayer.hasStatusEffect(Status.INVINCIBLE) and not eventPlayer.hasStatusEffect(Status.UNKILLABLE), 1)
        wait()
    # If the player is duplicating a hero, wait until Echo is no longer invulnerable
    if eventPlayer.isDuplicatingAHero():
        waitUntil(not eventPlayer.hasStatusEffect(Status.INVINCIBLE) and not eventPlayer.hasStatusEffect(Status.UNKILLABLE), 1)
        wait()

    ## Applying Custom Health ##
    # Apply an unkillable status so we don't accidentally kill the player
    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, 1)
    # Damage the player so they're at one health
    damage(eventPlayer, null, Math.INFINITY)

    wait()

    # Apply temporary base health to the player
    eventPlayer.addHealthPool(Health.NORMAL, Math.INFINITY, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, Math.INFINITY, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, Math.INFINITY, true, true)

    wait()

    # Remove temporary base health from the player
    eventPlayer.removeAllHealthPools()

    wait()


    # Apply custom health pool to player
    if eventPlayer.health_normal > 0:
        eventPlayer.addHealthPool(Health.NORMAL, max(1, eventPlayer.health_normal - 1), true, true)
    if eventPlayer.health_armor > 0:
        eventPlayer.addHealthPool(Health.ARMOR, max(1, eventPlayer.health_armor), true, true)
    if eventPlayer.health_shields > 0:
        eventPlayer.addHealthPool(Health.SHIELDS, max(1, eventPlayer.health_shields), true, true)
    heal(eventPlayer, null, Math.INFINITY)

    # Teleport player back if they were in spawn.
    if eventPlayer.storedSpawnPosition:
        wait(0.016)
        eventPlayer.teleport(eventPlayer.storedSpawnPosition)
        eventPlayer.storedSpawnPosition = null
        eventPlayer.stopCamera()


rule "[custom_health_handler.opy]: Remove Custom Health Conditions":
    @Event eachPlayer

    # Health pools persist between hero switching, so we remove it when player's switch or duplicate to another hero, or when D.Va switches between forms.
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()) or (isHero(eventPlayer, Hero.DVA) and eventPlayer.isInAlternateForm() != evalOnce(eventPlayer.isInAlternateForm())), 9999)

    clearCustomHealth()

    wait(0.016)

    if RULE_CONDITION: goto RULE_START
