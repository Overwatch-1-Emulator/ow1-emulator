#!mainFile "../main.opy"


playervar temp_shield_pvar
#!defineMember sound_barrier_amount temp_shield_pvar[0]
#!defineMember best_defense_shields temp_shield_pvar[1]
#!defineMember shield_pvar temp_shield_pvar[2]
#!defineMember armor_pvar temp_shield_pvar[3]
#!defineMember armor_pvar_id temp_shield_pvar[4]
#!defineMember shield_pvar_id temp_shield_pvar[5]
#!defineMember adaptive_shield_amount temp_shield_pvar[6]
#!defineMember grasp_amount temp_shield_pvar[7]
#!defineMember overload_amount temp_shield_pvar[8]
#!defineMember pre_beat_health temp_shield_pvar[9]

playervar pvar_id
#!defineMember _torbjorn_overload_id pvar_id[0]
#!defineMember _rally_pool_id pvar_id[1]
#!defineMember _adaptive_shield_hp_id pvar_id[2]
#!defineMember best_defense_pool_id pvar_id[3]
#!defineMember _grasp_pool_id pvar_id[4]


# The reason this is here is because when beat activates to get rid of temp armor and shield we have to strip it
# This puts the pools back to its original id so it can be removed

# These are just a bunch of macros for finding overhealth temp shield temp armor
macro getMissingHp(player):
    (player.getMaxHealth() - player.getHealth())


macro getNaturalArmor(player):
    ((player.getMaxHealthOfType(Health.NORMAL) + player.getMaxHealthOfType(Health.ARMOR)) - player.getHealthOfType(Health.NORMAL) - getMissingHp(player))
macro getTempArmor(player):
    (max(0, player.getHealthOfType(Health.ARMOR) - getNaturalArmor(player)) * min(1, player.getMaxHealthOfType(Health.ARMOR)))

macro getMissingArmor(player):
    (player.getMaxHealthOfType(Health.ARMOR) - player.getHealthOfType(Health.ARMOR))
macro getMissingShields(player):
    (player.getMaxHealthOfType(Health.SHIELDS) - player.getHealthOfType(Health.SHIELDS))

macro getNaturalShields(player):
    ((player.getMaxHealthOfType(Health.NORMAL) + player.getMaxHealthOfType(Health.SHIELDS)) - player.getHealthOfType(Health.NORMAL) - getMissingHp(player))
macro getTempShields(player):
    (max(0, player.getHealthOfType(Health.SHIELDS) - getNaturalShields(player)) * min(1, player.getMaxHealthOfType(Health.SHIELDS)))

macro getOverhealth(player):
    (player.getMaxHealth() - player.getMaxHealthOfType(Health.NORMAL) - player.getMaxHealthOfType(Health.ARMOR) - player.getMaxHealthOfType(Health.SHIELDS))

macro getCurrentOverhealth(player):
    max(0, player.getHealthOfType(Health.NORMAL) - player.getMaxHealthOfType(Health.NORMAL))

macro getHealthPercent(player):
    (player.getHealth() / player.getMaxHealth())
macro getNormalHealthPercent(player):
    (player.getHealthOfType(Health.NORMAL) / max(1, player.getMaxHealthOfType(Health.NORMAL)))
macro getArmorPercent(player):
    (player.getHealthOfType(Health.ARMOR) / max(1, player.getMaxHealthOfType(Health.ARMOR)))
macro getShieldsPercent(player):
    (player.getHealthOfType(Health.SHIELDS) / max(1, player.getMaxHealthOfType(Health.SHIELDS)))

macro isFullHealth(player):
    (getMissingHp(player) <= 0)
macro hasArmor(player):
    (player.getHealthOfType(Health.ARMOR) > 0)
macro hasShields(player):
    (player.getHealthOfType(Health.SHIELDS) > 0)

macro getNaturalHealth(player):
    (player.getHealthOfType(Health.NORMAL) + getNaturalArmor(player) + getNaturalShields(player))
macro getNaturalMaxHealth(player):
    (player.getMaxHealthOfType(Health.NORMAL) + player.getMaxHealthOfType(Health.ARMOR) + player.getMaxHealthOfType(Health.SHIELDS))
macro getNaturalMissingHealth(player):
    (getNaturalMaxHealth(player) - getNaturalHealth(player))

macro getTotalExtraHealth(player):
    (getTempArmor(player) + getTempShields(player))
macro isOverhealed(player):
    (getTotalExtraHealth(player) > 0)
    
# This is a global tracking system for different types of health pools to add back temp shields/armor
# DONT MOVE ANYTHING