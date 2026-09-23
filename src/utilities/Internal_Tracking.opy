#!mainFile "../main.opy"


# This is a global tracking system for different types of health pools to add back temp shields/armor
# DONT MOVE ANYTHING

playervar _damage_calculation

playervar healthpool_pvar
#!defineMember sound_barrier_amount healthpool_pvar[0]
#!defineMember best_defense_shields healthpool_pvar[1]
#!defineMember temp_pre_beat_shield_health healthpool_pvar[2]
#!defineMember temp_pre_beat_armor_health healthpool_pvar[3]
#!defineMember pre_beat_armor_health healthpool_pvar[4]
#!defineMember pre_beat_shield_health healthpool_pvar[5]
#!defineMember adaptive_shield_amount healthpool_pvar[6]
#!defineMember grasp_amount healthpool_pvar[7]
#!defineMember overload_amount healthpool_pvar[8]
#!defineMember pre_beat_health healthpool_pvar[9]
#!defineMember pre_beat_overhealth healthpool_pvar[10]
#!defineMember tracked_health_swap healthpool_pvar[11]

playervar pvar_id
#!defineMember _torbjorn_overload_id pvar_id[0]
#!defineMember _rally_pool_id pvar_id[1]
#!defineMember _adaptive_shield_hp_id pvar_id[2]
#!defineMember best_defense_pool_id pvar_id[3]
#!defineMember _grasp_pool_id pvar_id[4]
#!defineMember temp_pre_beat_armor_health_id pvar_id[5]
#!defineMember temp_pre_beat_shield_health_id pvar_id[6]


def resetPoolTrackers():
    @Name "[utilities/Internal_Tracking.opy]: resetPoolTrackers()"
    # Called by clearCustomHp() right after removeAllHealthPools(). Those pools are gone,
    # so their tracked amounts/ids must go too; otherwise stale values survive a hero
    # switch (e.g. Best Defense shields, Overload armor) and get re-added later by
    # Sound Barrier's pool restore, or confuse checks like the Wrecking Ball ult-charge rule.
    eventPlayer.healthpool_pvar = []
    eventPlayer.pvar_id = []


# The reason this is here is because when beat activates to get rid of temp armor and shield we have to strip it
# This puts the pools back to its original id so it can be removed

# These are just a bunch of macros for finding overhealth temp shield temp armor
macro getMissingHp(player):
    (player.getMaxHealth() - player.getHealth())


macro getNaturalArmor(player):
    max(0, player.getHealthOfType(Health.NORMAL) + player._hp_armor + player.getHealthOfType(Health.SHIELDS) - player.getHealthOfType(Health.SHIELDS) - player.getHealthOfType(Health.NORMAL) - getMissingHp(player))
macro getTempArmor(player):
    max(0, player.getHealthOfType(Health.ARMOR) - getNaturalArmor(player))


macro getMissingArmor(player):
    (player.getMaxHealthOfType(Health.ARMOR) - player.getHealthOfType(Health.ARMOR))
macro getMissingShields(player):
    (player.getMaxHealthOfType(Health.SHIELDS) - player.getHealthOfType(Health.SHIELDS))

macro getNaturalShields(player):
    max(0, player.getHealthOfType(Health.NORMAL) + player._hp_shields + player.getHealthOfType(Health.ARMOR) - player.getHealthOfType(Health.ARMOR) - player.getHealthOfType(Health.NORMAL) - getMissingHp(player))
macro getTempShields(player):
    max(0, player.getHealthOfType(Health.SHIELDS) - getNaturalShields(player))

macro getNaturalHealth(player):
    max(0, player.getHealthOfType(Health.ARMOR) + player._hp_health + player.getHealthOfType(Health.SHIELDS) - player.getHealthOfType(Health.SHIELDS) - player.getHealthOfType(Health.ARMOR) - getMissingHp(player))


macro getCurrentOverhealth(player):
    max(0, player.getHealthOfType(Health.NORMAL) - getNaturalHealth(player))
    

macro removeOverhealth(player):
    (player.setHealth(player.getHealth()) - getCurrentOverhealth(player))

macro getNaturalNormalHealth(player):
    min(player.getHealthOfType(Health.NORMAL), player._hp_health)
    
macro getNaturalMaxHealth(player):
    (player.getMaxHealthOfType(Health.NORMAL) + player.getMaxHealthOfType(Health.ARMOR) + player.getMaxHealthOfType(Health.SHIELDS))
macro getNaturalMissingHealth(player):
    (getNaturalMaxHealth(player) - getNaturalHealth(player))

macro getTotalExtraHealth(player):
    (getTempArmor(player) + getTempShields(player))
macro isOverhealed(player):
    (getTotalExtraHealth(player) > 0)

macro ow2ArmorApplied(raw):
    ((raw) - min(OW2_ARMOR_DAMAGE_REDUCTION_PERCENT*(raw), OW2_ARMOR_DAMAGE_REDUCTION))

macro ow2ArmorRawFor(applied):
    ((applied)/(1 - OW2_ARMOR_DAMAGE_REDUCTION_PERCENT) \
     if (applied) < OW2_ARMOR_DAMAGE_REDUCTION*(1 - OW2_ARMOR_DAMAGE_REDUCTION_PERCENT)/OW2_ARMOR_DAMAGE_REDUCTION_PERCENT \
     else (applied) + OW2_ARMOR_DAMAGE_REDUCTION)

# OW1 armor: flat 5, or half for small hits
macro ow1ArmorApplied(raw):
    ((raw) - min(OW1_ARMOR_DAMAGE_REDUCTION, (raw)/2))

    
# This tracks what temp armor/shield receives the damage if multiple healthpools are applied
rule "[utilities/Internal_Tracking.opy]: Track event damage dealt to beat":
    @Event playerTookDamage
    @Condition eventPlayer.sound_barrier_amount > 0

    eventPlayer.sound_barrier_amount -= eventDamage + 0
    if eventPlayer.sound_barrier_amount < 0:
        eventPlayer._damage_calculation = eventPlayer.sound_barrier_amount


rule "[utilities/Internal_Tracking.opy]: Track event damage dealt to Best Defense":
    @Event playerTookDamage
    @Hero doomfist
    @Condition eventPlayer.best_defense_shields > 0
    @Condition eventPlayer.sound_barrier_amount == 0 and eventPlayer.getHealthOfType(Health.ARMOR) == 0 

    eventPlayer.best_defense_shields -= eventDamage

rule "[utilities/Internal_Tracking.opy]: Track event damage dealt to Grasp":
    @Event playerTookDamage
    @Hero sigma
    @Condition eventPlayer.grasp_amount > 0
    @Condition eventPlayer.sound_barrier_amount == 0 and eventPlayer.getHealthOfType(Health.ARMOR) == 0

    eventPlayer.grasp_amount -= eventDamage

rule "[utilities/Internal_Tracking.opy]: Track event damage dealt to Adaptive Shield":
    @Event playerTookDamage
    @Hero wreckingBall
    @Condition eventPlayer.adaptive_shield_amount > 0
    @Condition eventPlayer.sound_barrier_amount == 0 and getTempArmor(eventPlayer) > 0
    
    eventPlayer.adaptive_shield_amount -= eventDamage

rule "[utilities/Internal_Tracking.opy]: Track event damage dealt to Overload":
    @Event playerTookDamage
    @Hero wreckingBall
    @Condition eventPlayer.overload_amount > 0
    @Condition eventPlayer.sound_barrier_amount == 0 and eventPlayer._rally_pool_id == null

    eventPlayer.overload_amount -= eventDamage

rule "[utilities/Internal_Tracking.opy]: Track event damage dealt to Rally":
    @Event playerTookDamage
    @Condition eventPlayer.sound_barrier_amount == 0
    #@Condition eventPlayer.rally_armor_amount > 0

























    
