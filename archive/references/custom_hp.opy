# Credit to https://discord.com/channels/570672959799164958/1095384108504465488
# Base code written by CaptCaptain
playervar custom_hp_pvar
#!defineMember hp_health custom_hp_pvar[0]
#!defineMember hp_armor custom_hp_pvar[1]
#!defineMember hp_shields custom_hp_pvar[2]
#!defineMember stored_spawn_pos custom_hp_pvar[3]

subroutine clearCustomHp
subroutine applyCustomHp

#!define isHero(player, hero) ((player.getCurrentHero() == hero) or (player.getHeroOfDuplication() == hero))

# setCustomHp(0, 0, 0) simply clears the hero's hp
#!define setCustomHp(health, armor, shields)\
    eventPlayer.hp_health = health\
    eventPlayer.hp_armor = armor\
    eventPlayer.hp_shields = shields\
    applyCustomHp()


def clearCustomHp():
    @Name "[custom_hp.opy]: clearCustomHp()"

    eventPlayer.removeAllHealthPools()
    wait()
    eventPlayer.setMaxHealth(100.001)
    wait()
    eventPlayer.setMaxHealth(100)
    heal(eventPlayer, null, Math.INFINITY)


def applyCustomHp():
    @Name "[custom_hp.opy]: applyCustomHp()"

    if (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields <= 0):
        clearCustomHp()
        return
    
    waitUntil(eventPlayer.hasSpawned(), Math.INFINITY)
    # If the player is in spawn, teleport them out as they are invulnerable in spawn
    if eventPlayer.isInSpawnRoom():
        eventPlayer.stored_spawn_pos = eventPlayer.getPosition()
        wait()
        eventPlayer.setGravity(0)
        eventPlayer.teleport(eventPlayer.getPosition() + 100 * (Vector.FORWARD if getCurrentGamemode() == Gamemode.CONTROL else Vector.UP)) # TP horizontally on control maps
        waitUntil(not (eventPlayer.isInSpawnRoom() or eventPlayer.hasStatusEffect(Status.INVINCIBLE) or eventPlayer.hasStatusEffect(Status.UNKILLABLE)), Math.INFINITY)
        eventPlayer.setGravity(100)
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
        eventPlayer.teleport(eventPlayer.stored_spawn_pos)
        eventPlayer.stored_spawn_pos = null


rule "[custom_hp.opy]: Remove Custom Health Conditions":
    @Event eachPlayer

    # Health pools persist between hero switching, so we remove it when player's switch or duplicate to another hero, or when D.Va switches between forms.
    waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()) or (isHero(eventPlayer, Hero.DVA) and eventPlayer.isInAlternateForm() != evalOnce(eventPlayer.isInAlternateForm())), Math.INFINITY)

    clearCustomHp()

    wait()

    if RULE_CONDITION: goto RULE_START
