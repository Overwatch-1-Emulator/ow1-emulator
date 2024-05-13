#!mainFile "../dev_main.opy"

# Credit to https://discord.com/channels/570672959799164958/1095384108504465488
# Base code written by CaptCaptain and cactuspuppy
playervar custom_hp_pvar
#!defineMember _hp_health custom_hp_pvar[0]
#!defineMember _hp_armor custom_hp_pvar[1]
#!defineMember _hp_shields custom_hp_pvar[2]
#!defineMember _hp_iter_count custom_hp_pvar[3]

#!define MIN_HP 1
#!define HP_ROUNDING_ERROR_MARGIN 0.01
#!define MAX_HP_ITER_COUNT 10

subroutine clearCustomHp
subroutine applyCustomHp

# setCustomHp(0, 0, 0) simply clears the hero's hp
#!define setCustomHp(health, armor, shields)\
    eventPlayer._hp_health = health\
    eventPlayer._hp_armor = armor\
    eventPlayer._hp_shields = shields\
    applyCustomHp()


def clearCustomHp():
    @Name "[utilities/custom_hp.opy]: clearCustomHp()"

    eventPlayer.removeAllHealthPools()
    wait()
    eventPlayer.setMaxHealth(100.001)
    wait()
    eventPlayer.setMaxHealth(100)
    heal(eventPlayer, null, Math.INFINITY)

def applyCustomHp():
    @Name "[utilities/custom_hp.opy]: applyCustomHp()"

    eventPlayer._hp_iter_count = 0

    # loop MAX_HP_ITER_COUNT times if hp is incorrect
    while (((abs(eventPlayer.getMaxHealthOfType(Health.NORMAL) - eventPlayer._hp_health) > HP_ROUNDING_ERROR_MARGIN)\
         or (abs(eventPlayer.getMaxHealthOfType(Health.ARMOR) - eventPlayer._hp_armor) > HP_ROUNDING_ERROR_MARGIN)\
         or (abs(eventPlayer.getMaxHealthOfType(Health.SHIELDS) - eventPlayer._hp_shields) > HP_ROUNDING_ERROR_MARGIN))\
       and (eventPlayer._hp_iter_count < MAX_HP_ITER_COUNT)):
    
        eventPlayer.setHealingReceived(0)

        waitUntil(eventPlayer.hasSpawned(), Math.INFINITY)
        waitUntil(not (eventPlayer.hasStatusEffect(Status.INVINCIBLE) \
                    or eventPlayer.hasStatusEffect(Status.UNKILLABLE)), Math.INFINITY)

        wait()

        eventPlayer.setHealth(MIN_HP)
        eventPlayer.addHealthPool(Health.NORMAL, MIN_HP, true, true)
        eventPlayer.addHealthPool(Health.ARMOR, MIN_HP, true, true)
        eventPlayer.addHealthPool(Health.SHIELDS, MIN_HP, true, true)
        # Apply an unkillable status so we don't accidentally kill the player
        eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, Math.INFINITY)

        eventPlayer.removeAllHealthPools()

        # wait(0.064)
        wait()
        waitUntil(eventPlayer.getMaxHealth() <= MIN_HP, 1)

        # Apply custom health pool to player
        if eventPlayer._hp_health > 0:
            eventPlayer.addHealthPool(Health.NORMAL, max(1, eventPlayer._hp_health - MIN_HP), true, true)
        if eventPlayer._hp_armor > 0:
            eventPlayer.addHealthPool(Health.ARMOR, max(1, eventPlayer._hp_armor), true, true)
        if eventPlayer._hp_shields > 0:
            eventPlayer.addHealthPool(Health.SHIELDS, max(1, eventPlayer._hp_shields), true, true)
        eventPlayer.setHealingReceived(100)
        heal(eventPlayer, null, Math.INFINITY)
        eventPlayer.clearStatusEffect(Status.UNKILLABLE)

        wait()
        eventPlayer._hp_iter_count += 1


# rule "[custom_hp.opy]: Remove Custom Health Conditions":
#     @Event eachPlayer

#     # Health pools persist between hero switching, so we remove it when player's switch or duplicate to another hero, or when D.Va switches between forms.
#     waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()) or (isHero(eventPlayer, Hero.DVA) and eventPlayer.isInAlternateForm() != evalOnce(eventPlayer.isInAlternateForm())), Math.INFINITY)

#     clearCustomHp()

#     wait()

#     if RULE_CONDITION: goto RULE_START
