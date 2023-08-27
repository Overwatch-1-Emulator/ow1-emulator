#!mainFile "../main.opy"

# Credit to https://discord.com/channels/570672959799164958/1095384108504465488
# Base code written by CaptCaptain
playervar hp_health
playervar hp_armor
playervar hp_shields

#!define setCustomHealth(health, armor, shields)\
    eventPlayer.hp_health = health\
    eventPlayer.hp_armor = armor\
    eventPlayer.hp_shields = shields\
    applyCustomHealth()
#!define isHero(player, hero) (player.getCurrentHero() == hero or player.getHeroOfDuplication() == hero)

playervar stored_spawn_pos

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
        eventPlayer.stored_spawn_pos = eventPlayer.getPosition()
        eventPlayer.teleport(eventPlayer.getPosition() + 100 * Vector.UP)
        waitUntil(not (eventPlayer.isInSpawnRoom() or eventPlayer.hasStatusEffect(Status.INVINCIBLE) or eventPlayer.hasStatusEffect(Status.UNKILLABLE)), 1)
        wait()
    # If the player is duplicating a hero, wait until Echo is no longer invulnerable
    if eventPlayer.isDuplicatingAHero():
        waitUntil(not (eventPlayer.hasStatusEffect(Status.INVINCIBLE) or eventPlayer.hasStatusEffect(Status.UNKILLABLE)), 1)
        wait()

    ## Applying Custom Health ##
    # Apply an unkillable status so we don't accidentally kill the player
    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, Math.INFINITY)
    # Damage the player so they're at one health
    damage(eventPlayer, null, Math.INFINITY)

    waitUntil(eventPlayer.getHealth() <= 1, 1)

    # Apply temporary base health to the player
    eventPlayer.addHealthPool(Health.NORMAL, Math.INFINITY, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, Math.INFINITY, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, Math.INFINITY, true, true)

    # Remove temporary base health from the player
    eventPlayer.removeAllHealthPools()

    waitUntil(eventPlayer.getMaxHealth() <= 1, 1)


    # Apply custom health pool to player
    if eventPlayer.hp_health > 0:
        eventPlayer.addHealthPool(Health.NORMAL, max(1, eventPlayer.hp_health - 1), true, true)
    if eventPlayer.hp_armor > 0:
        eventPlayer.addHealthPool(Health.ARMOR, max(1, eventPlayer.hp_armor), true, true)
    if eventPlayer.hp_shields > 0:
        eventPlayer.addHealthPool(Health.SHIELDS, max(1, eventPlayer.hp_shields), true, true)
    heal(eventPlayer, null, Math.INFINITY)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)

    # Teleport player back if they were in spawn.
    if eventPlayer.stored_spawn_pos != null:
        wait()
        eventPlayer.teleport(eventPlayer.stored_spawn_pos)
        eventPlayer.stored_spawn_pos = null
        eventPlayer.stopCamera()

    
    wait()
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START


rule "[custom_health_handler.opy]: Remove Custom Health Conditions":
    @Event eachPlayer
    @Disabled

    # Health pools persist between hero switching, so we remove it when player's switch or duplicate to another hero, or when D.Va switches between forms.
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()) or (isHero(eventPlayer, Hero.DVA) and eventPlayer.isInAlternateForm() != evalOnce(eventPlayer.isInAlternateForm())), 9999)

    clearCustomHealth()

    wait(0.016)

    if RULE_CONDITION: goto RULE_START
