#!mainFile "../main.opy"


playervar temp_shield_pvar
#!defineMember sound_barrier_amount temp_shield_pvar[0]
#!defineMember _torbjorn_overload_id temp_shield_pvar[1]
#!defineMember best_defense_shields temp_shield_pvar[2]


macro getMissingHp():
    (eventPlayer.getMaxHealth() - eventPlayer.getHealth())
macro getNaturalArmor():
    ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
macro getExtraArmor():
    max(0, eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())

macro getMissingArmor():
    (eventPlayer.getMaxHealthOfType(Health.ARMOR) - eventPlayer.getHealthOfType(Health.ARMOR))
macro getMissingShields():
    (eventPlayer.getMaxHealthOfType(Health.SHIELDS) - eventPlayer.getHealthOfType(Health.SHIELDS))

macro getNaturalShields():
    ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.SHIELDS)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
macro getExtraShields():
    max(0, eventPlayer.getHealthOfType(Health.SHIELDS) - getNaturalShields())

macro isFullHealth():
    (getMissingHp() <= 0)
macro hasArmor():
    (eventPlayer.getHealthOfType(Health.ARMOR) > 0)
macro hasShields():
    (eventPlayer.getHealthOfType(Health.SHIELDS) > 0)

macro getNaturalHealth():
    (eventPlayer.getHealthOfType(Health.NORMAL) + getNaturalArmor() + getNaturalShields())
macro getNaturalMaxHealth():
    (eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS))
macro getNaturalMissingHealth():
    (getNaturalMaxHealth() - getNaturalHealth())

macro getTotalExtraHealth():
    (getExtraArmor() + getExtraShields())
macro isOverhealed():
    (getTotalExtraHealth() > 0)

# This is a global tracking system for different types of health pools to add back temp shields/armor
# DONT MOVE ANYTHING