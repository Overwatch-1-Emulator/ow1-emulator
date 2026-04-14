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
        if victim.getHealthOfType(Health.ARMOR) > 0:
            damage(victim, attacker, ((OW1_MELEE_DAMAGE_VS_ARMOR/OW2_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
        else:
            damage(victim, attacker, ((OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
