#!mainFile "../main.opy"

playervar emu_helper_pvar
#!defineMember _base_damage_scalar emu_helper_pvar[0]
#!defineMember _base_healing_scalar emu_helper_pvar[1]
#!defineMember _base_movement_scalar emu_helper_pvar[2]
##!defineMember _damage_received_scalar emu_helper_pvar [3]
playervar hack_timer

macro setBaseDamage(player, scalar):
    player._base_damage_scalar = scalar
    player.setDamageDealt(percent(player._base_damage_scalar))

macro setBaseHealing(player, scalar):
    player._base_healing_scalar = scalar
    player.setHealingDealt(percent(player._base_healing_scalar))

macro setBaseMovement(player, scalar):
    player._base_movement_scalar = scalar
    player.setMoveSpeed(percent(player._base_movement_scalar))

#macro setDamageReceived(player, scalar):
#    player._damage_received_scalar = scalar
#    player.setDamageReceived(percent(player._damage_received_scalar))

macro getProjectileSpeed(player):
    # Hitscan heroes return 0 (instant)
    # Ana, Ashe (primary), Baptiste (primary), Cassidy, D.Va (minigun), 
    # Reaper, Soldier 76, Sombra, Tracer, Widowmaker, Zenyatta (orbs are projectile actually)
    0 if player.getCurrentHero() in [Hero.ANA, Hero.ASHE, Hero.BAPTISTE, Hero.CASSIDY, 
                                       Hero.DVA, Hero.REAPER, Hero.SOLDIER_76, Hero.SOMBRA, 
                                       Hero.TRACER, Hero.WIDOWMAKER] \
    else OW1_PHARAH_ROCKET_SPEED if player.getCurrentHero() == Hero.PHARAH \
    else OW1_GENJI_PROJECTILE_SPEED if player.getCurrentHero() == Hero.GENJI \
    else OW1_HANZO_ARROW_SPEED if player.getCurrentHero() == Hero.HANZO \
    else OW1_JUNKRAT_PROJECTILE if player.getCurrentHero() == Hero.JUNKRAT \
    else OW1_ORISA_GUN_PROJECTILE_SPEED if player.getCurrentHero() == Hero.ORISA \
    else OW1_SIGMA_PROJECTILE_SPEED if player.getCurrentHero() == Hero.SIGMA \
    else OW1_REINHARDT_FIRESTRIKE_SPEED if player.getCurrentHero() == Hero.REINHARDT \
    else OW1_ZENYATTA_ORB_SPEED if player.getCurrentHero() == Hero.ZENYATTA \
    else OW1_SYMMETRA_ORB_SPEED if player.getCurrentHero() == Hero.SYMMETRA \
    else OW1_LUCIO_PROJECTILE_SPEED if player.getCurrentHero() == Hero.LUCIO \
    else OW1_MEI_ICICLE_SPEED if player.getCurrentHero() == Hero.MEI \
    else 60
macro isHacked(player):
    player.hack_timer > 0

macro isCCd(player):
    (player.hasStatusEffect(Status.STUNNED) \
  or isHacked(player) \
  or player.hasStatusEffect(Status.ASLEEP) \
  or player.hasStatusEffect(Status.FROZEN) \
  or player.hasStatusEffect(Status.KNOCKED_DOWN))

rule "[utilities/emu_helper.opy]: OW1 melee damage":
    @Event playerDealtDamage
    @Condition eventAbility == Button.MELEE
    @Condition eventPlayer.getCurrentHero() not in [Hero.BRIGITTE, Hero.REINHARDT, Hero.ZENYATTA]

    if eventPlayer.getCurrentHero() in [Hero.SYMMETRA, Hero.TORBJORN, Hero.ASHE]:
        heal(victim, null, eventDamage - (OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))
        damage(victim, attacker, ((OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, ((OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
