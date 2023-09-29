#!mainFile "../main.opy"

playervar call_init

playervar player_health

playervar friendly_doomfist_player
playervar friendly_orisa_player
playervar friendly_sombra_player

playervar enemy_doomfist_player
playervar enemy_orisa_player
playervar enemy_sombra_player

subroutine resetAbilities
subroutine resetStats
subroutine resetStatuses
subroutine resetFrenemies


def resetAbilities():
    @Name "[reset.opy]: resetAbilities()"

    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)

    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.INTERACT)

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)

    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setCrouchEnabled(true)
    eventPlayer.setReloadEnabled(true)


def resetStats():
    @Name "[reset.opy]: resetStats()"

    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setHealingDealt(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)


def resetStatuses():
    @Name "[reset.opy]: resetStatuses()"

    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.clearStatusEffect(Status.FROZEN)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.STUNNED)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)


def resetFrenemies():
    @Name "[reset.opy]: resetFrenemies()"

    eventPlayer.friendly_doomfist_player = getPlayersOnHero(Hero.DOOMFIST, eventPlayer.getTeam())[0]
    eventPlayer.enemy_doomfist_player = getPlayersOnHero(Hero.DOOMFIST, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.friendly_orisa_player = getPlayersOnHero(Hero.ORISA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_orisa_player = getPlayersOnHero(Hero.ORISA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.friendly_sombra_player = getPlayersOnHero(Hero.SOMBRA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_sombra_player = getPlayersOnHero(Hero.SOMBRA, getOppositeTeam(eventPlayer.getTeam()))[0]

    
rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds()
    @Condition isGameInProgress()

    waitUntil(not isMatchBetweenRounds(), Math.INFINITY)
    eventPlayer.call_init = true


def respawnSameState():
    @Name "[reset.opy]: respawnSameState()"
    
    eventPlayer.player_health = eventPlayer.getHealth()
    kill(eventPlayer,null)
    # Use resurrect to keep the same position and angle
    eventPlayer.resurrect()
    # Wait to set health else the player will be full life
    wait()
    eventPlayer.setHealth(eventPlayer.player_health)
