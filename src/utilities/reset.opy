#!mainFile "../main.opy"

playervar call_reset
playervar call_init

playervar text_huds
playervar progress_bar_huds
playervar entity_huds

playervar player_health

playervar friendly_doomfist_player
playervar friendly_orisa_player
playervar friendly_sombra_player

playervar enemy_doomfist_player
playervar enemy_orisa_player
playervar enemy_sombra_player

subroutine resetHero
subroutine initHero

def resetHero():
    @Name "[reset.opy]: resetHero()"

    eventPlayer.call_reset = true
    wait() # Call other reset functions
    eventPlayer.call_reset = false


def initHero():
    @Name "[reset.opy]: initHero()"

    eventPlayer.call_init = true
    wait() # Call other init functions
    eventPlayer.call_init = false


rule "[reset.opy]: Reset abilities":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

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


rule "[reset.opy]: Reset stats":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setHealingDealt(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)


rule "[reset.opy]: Reset statuses":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

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


rule "[reset.opy]: Reset friendly/enemy players":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    eventPlayer.friendly_doomfist_player = getPlayersOnHero(Hero.DOOMFIST, eventPlayer.getTeam())[0]
    eventPlayer.enemy_doomfist_player = getPlayersOnHero(Hero.DOOMFIST, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.friendly_orisa_player = getPlayersOnHero(Hero.ORISA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_orisa_player = getPlayersOnHero(Hero.ORISA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.friendly_sombra_player = getPlayersOnHero(Hero.SOMBRA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_sombra_player = getPlayersOnHero(Hero.SOMBRA, getOppositeTeam(eventPlayer.getTeam()))[0]


rule "[reset.opy]: Reset HUDs and GUI":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    # Clear GUI
    for i in range(len(eventPlayer.text_huds)):
        destroyHudText(eventPlayer.text_huds[i])
    for i in range(len(eventPlayer.progress_bar_huds)):
        destroyProgressBarHud(eventPlayer.progress_bar_huds[i])
    for i in range(len(eventPlayer.entity_huds)):
        destroyEffect(eventPlayer.entity_huds[i])

    eventPlayer.text_huds = []
    eventPlayer.progress_bar_huds = []
    eventPlayer.entity_huds = []

    
rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true

    waitUntil(not isMatchBetweenRounds(), Math.INFINITY)
    resetHero()
    initHero()


rule "[reset.opy]: Reinitialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    resetHero()
    initHero()


def respawnSameState():
    @Name "[reset.opy]: respawnSameState()"
    
    eventPlayer.player_health = eventPlayer.getHealth()
    kill(eventPlayer,null)
    # Use resurrect to keep the same position and angle
    eventPlayer.resurrect()
    # Wait to set health else the player will be full life
    wait()
    eventPlayer.setHealth(eventPlayer.player_health)
