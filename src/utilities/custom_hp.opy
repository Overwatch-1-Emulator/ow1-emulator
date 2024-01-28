#!mainFile "../main.opy"

# Credit to https://discord.com/channels/570672959799164958/1095384108504465488
# Base code written by CaptCaptain and cactuspuppy
playervar custom_hp_pvar
#!defineMember hp_health custom_hp_pvar[0]
#!defineMember hp_armor custom_hp_pvar[1]
#!defineMember hp_shields custom_hp_pvar[2]

subroutine clearCustomHp
subroutine applyCustomHp

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
    waitUntil(not (eventPlayer.hasStatusEffect(Status.INVINCIBLE) \
                or eventPlayer.hasStatusEffect(Status.UNKILLABLE)), Math.INFINITY)

    wait()

    eventPlayer.setHealingReceived(0)
    eventPlayer.setHealth(1)
    eventPlayer.addHealthPool(Health.NORMAL, 1, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 1, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 1, true, true)

    # wait(0.064)
    wait()

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

    #Restore normal healing
    eventPlayer.setHealingReceived(100)


# rule "[custom_hp.opy]: Remove Custom Health Conditions":
#     @Event eachPlayer

#     # Health pools persist between hero switching, so we remove it when player's switch or duplicate to another hero, or when D.Va switches between forms.
#     waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()) or (isHero(eventPlayer, Hero.DVA) and eventPlayer.isInAlternateForm() != evalOnce(eventPlayer.isInAlternateForm())), Math.INFINITY)

#     clearCustomHp()

#     wait()

#     if RULE_CONDITION: goto RULE_START
