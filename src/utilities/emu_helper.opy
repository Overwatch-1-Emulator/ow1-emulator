#!mainFile "../main.opy"

playervar emu_helper_pvar
#!defineMember _base_damage_scalar emu_helper_pvar[0]
#!defineMember _base_healing_scalar emu_helper_pvar[1]
#!defineMember _base_movement_scalar emu_helper_pvar[2]
##!defineMember _damage_received_scalar emu_helper_pvar [3]
playervar hack_end_time # getTotalTimeElapsed() when OW1 hack ends; timestamp instead of a chased timer so conditions using isCCd() re-trigger reliably

macro setBaseDamage(player, scalar):
    player._base_damage_scalar = scalar
    player.setDamageDealt(percent(player._base_damage_scalar))

macro setBaseHealing(player, scalar):
    player._base_healing_scalar = scalar
    player.setHealingDealt(percent(player._base_healing_scalar))

###############################################################################
# Movement speed system
# Every effect that changes a player's speed owns one MoveMod slot, and the final
# speed is always base * every active modifier. Effects no longer overwrite each
# other (e.g. Flashbang ending no longer cancels an active Halt slow).
#
# move_mods stores (1 - multiplier) per slot, so an unset slot (null/0) means x1.
# This also lets a multiplier of 0 (Bastion sentry) be stored, since in the
# Workshop null == 0 and a plain multiplier of 0 would look unset.
###############################################################################
enum MoveMod:
    HALT,           # Orisa Halt snare slow (victim)
    FLASHBANG,      # Cassidy Flashbang hinder compensation (victim)
    METEOR,         # Doomfist Meteor Strike slow compensation (victim)
    SHIELD_BASH,    # Brigitte Shield Bash distance reduction
    RALLY,          # Brigitte Rally speed buff
    DVA_GUN,        # D.Va shooting penalty
    DEADEYE,        # Cassidy Deadeye speed
    COALESCENCE,    # Moira Coalescence speed buff
    HOVER_JETS,     # Pharah Hover Jets speed
    STEALTH,        # Sombra Stealth speed
    BASTION_CONFIG  # Bastion recon (x1) / sentry (x0) / tank

playervar move_mods

macro moveMult(player, mod):
    (1 - player.move_mods[mod])

macro applyMovement(player):
    # (base falls back to x1 if a modifier lands before the player's first reset)
    player.setMoveSpeed(percent((player._base_movement_scalar if player._base_movement_scalar != 0 else 1) \
        * moveMult(player, MoveMod.HALT) \
        * moveMult(player, MoveMod.FLASHBANG) \
        * moveMult(player, MoveMod.METEOR) \
        * moveMult(player, MoveMod.SHIELD_BASH) \
        * moveMult(player, MoveMod.RALLY) \
        * moveMult(player, MoveMod.DVA_GUN) \
        * moveMult(player, MoveMod.DEADEYE) \
        * moveMult(player, MoveMod.COALESCENCE) \
        * moveMult(player, MoveMod.HOVER_JETS) \
        * moveMult(player, MoveMod.STEALTH) \
        * moveMult(player, MoveMod.BASTION_CONFIG)))

# Turn on (or change) one speed modifier, then recompute final speed
macro setMoveModifier(player, mod, multiplier):
    player.move_mods[mod] = 1 - (multiplier)
    applyMovement(player)

# Turn off one speed modifier, then recompute final speed
macro clearMoveModifier(player, mod):
    player.move_mods[mod] = 0
    applyMovement(player)

# Hero base speed (Orisa Fortify/Fusion Driver use this); keeps active modifiers
macro setBaseMovement(player, scalar):
    player._base_movement_scalar = scalar
    applyMovement(player)

#macro setDamageReceived(player, scalar):
#    player._damage_received_scalar = scalar
#    player.setDamageReceived(percent(player._damage_received_scalar))

macro isHacked(player):
    (getTotalTimeElapsed() < player.hack_end_time)

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
