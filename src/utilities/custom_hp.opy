#!mainFile "../dev_main.opy"

# Credit to https://discord.com/channels/570672959799164958/1095384108504465488
# Base code written by CaptCaptain and cactuspuppy
playervar custom_hp_pvar
#!defineMember _hp_health custom_hp_pvar[0]
#!defineMember _hp_armor custom_hp_pvar[1]
#!defineMember _hp_shields custom_hp_pvar[2]
#!defineMember _hp_health_ow2 custom_hp_pvar[3]
#!defineMember _hp_armor_ow2 custom_hp_pvar[4]
#!defineMember _hp_shields_ow2 custom_hp_pvar[5]
#!defineMember _hp_scalar custom_hp_pvar[6]

#!define MIN_HP 1
#!define HP_ROUNDING_ERROR_MARGIN 0.01

subroutine applyCustomHp

macro setCustomHp(health, armor, shields):
    eventPlayer._hp_health = health
    eventPlayer._hp_armor = armor
    eventPlayer._hp_shields = shields
    applyCustomHp()


def clearCustomHp():
    @Name "[utilities/custom_hp.opy]: clearCustomHp()"

    eventPlayer._hp_reset = false

    eventPlayer.removeAllHealthPools()
    wait()
    eventPlayer.setMaxHealth(100)
    wait()

    eventPlayer._hp_health = 0
    eventPlayer._hp_armor = 0
    eventPlayer._hp_shields = 0

    eventPlayer._hp_health_ow2 = eventPlayer.getMaxHealthOfType(Health.NORMAL)
    eventPlayer._hp_armor_ow2 = eventPlayer.getMaxHealthOfType(Health.ARMOR)
    eventPlayer._hp_shields_ow2 = eventPlayer.getMaxHealthOfType(Health.SHIELDS)

    eventPlayer._hp_scalar = 1

    eventPlayer._hp_reset = true


def applyCustomHp():
    @Name "[utilities/custom_hp.opy]: applyCustomHp()"

    if (eventPlayer.getMaxHealthOfType(Health.NORMAL) == eventPlayer._hp_health) and \
       (eventPlayer.getMaxHealthOfType(Health.ARMOR) == eventPlayer._hp_armor) and \
       (eventPlayer.getMaxHealthOfType(Health.SHIELDS) == eventPlayer._hp_shields):
       return

    # Find minimum hp scalar value that ensures
    # the scaled health/armor/shields is less or equal to
    # the desired custom health/armor/shield value
    eventPlayer._hp_scalar = \
        min(
            min(
                (eventPlayer._hp_health/eventPlayer._hp_health_ow2) if eventPlayer._hp_health_ow2 > 0 else Math.INFINITY, 
                (eventPlayer._hp_armor/eventPlayer._hp_armor_ow2)   if eventPlayer._hp_armor_ow2 > 0 else Math.INFINITY), 
            (eventPlayer._hp_shields/eventPlayer._hp_shields_ow2) if eventPlayer._hp_shields_ow2 > 0 else Math.INFINITY)

    # infinite hp scalar exception
    if eventPlayer._hp_scalar == Math.INFINITY:
        return

    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
    wait(TICK_DURATION)
    waitUntil(eventPlayer.getMaxHealth() != eventPlayer._hp_health_ow2 + eventPlayer._hp_armor_ow2 + eventPlayer._hp_shields_ow2, 1)
    if (eventPlayer._hp_health - eventPlayer.getMaxHealthOfType(Health.NORMAL)) >= 1:
        eventPlayer.addHealthPool(Health.NORMAL, (eventPlayer._hp_health - eventPlayer.getMaxHealthOfType(Health.NORMAL)), true, false)
    if (eventPlayer._hp_armor - eventPlayer.getMaxHealthOfType(Health.ARMOR)) >= 1:
        eventPlayer.addHealthPool(Health.ARMOR, (eventPlayer._hp_armor - eventPlayer.getMaxHealthOfType(Health.ARMOR)), true, false)
    if (eventPlayer._hp_shields - eventPlayer.getMaxHealthOfType(Health.SHIELDS)) >= 1:
        eventPlayer.addHealthPool(Health.SHIELDS, (eventPlayer._hp_shields - eventPlayer.getMaxHealthOfType(Health.SHIELDS)), true, false)


# rule "[custom_hp.opy]: Remove Custom Health Conditions":
#     @Event eachPlayer

#     # Health pools persist between hero switching, so we remove it when player's switch or duplicate to another hero, or when D.Va switches between forms.
#     waitUntil(eventPlayer.getCurrentHero() != evalOnce(eventPlayer.getCurrentHero()) or eventPlayer.getHeroOfDuplication() != evalOnce(eventPlayer.getHeroOfDuplication()) or (isHero(eventPlayer, Hero.DVA) and eventPlayer.isInAlternateForm() != evalOnce(eventPlayer.isInAlternateForm())), Math.INFINITY)

#     clearCustomHp()

#     wait()

#     if RULE_CONDITION: goto RULE_START
