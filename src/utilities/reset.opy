#!mainFile "../main.opy"

playervar call_reset
playervar call_initialize

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


rule "[reset.opy]: Call reset rules":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    wait() # Call other reset rules

    eventPlayer.friendly_doomfist_player = getPlayersOnHero(Hero.DOOMFIST, eventPlayer.getTeam())[0]
    eventPlayer.enemy_doomfist_player = getPlayersOnHero(Hero.DOOMFIST, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.friendly_orisa_player = getPlayersOnHero(Hero.ORISA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_orisa_player = getPlayersOnHero(Hero.ORISA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.friendly_sombra_player = getPlayersOnHero(Hero.SOMBRA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_sombra_player = getPlayersOnHero(Hero.SOMBRA, getOppositeTeam(eventPlayer.getTeam()))[0]

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

    eventPlayer.call_reset = false
    eventPlayer.call_initialize = true


rule "[reset.opy]: Call initialization rules":
    @Event eachPlayer
    @Condition eventPlayer.call_initialize == true # without this flag, the reset code executes out of order

    wait() # Call other initialization rules
    eventPlayer.call_initialize = false


rule "[reset.opy]: Reset general hero":
    @Event eachPlayer
    @Condition eventPlayer.call_reset == true

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.setMeleeEnabled(true)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.setUltEnabled(true)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setUltCharge(0)

    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setHealingDealt(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)

    eventPlayer.clearStatusEffect(Status.ROOTED)

    
rule "[reset.opy]: Reset hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true

    waitUntil(not isMatchBetweenRounds(), 9999)
    eventPlayer.call_reset = true


rule "[reset.opy]: Reset hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    wait()
    eventPlayer.call_reset = true


def respawnSameState():
    @Name "[reset.opy]: respawnSameState()"
    
    eventPlayer.player_health = eventPlayer.getHealth()
    kill(eventPlayer,null)
    # Use resurrect to keep the same position and angle
    eventPlayer.resurrect()
    # Wait to set health else the player will be full life
    wait()
    eventPlayer.setHealth(eventPlayer.player_health)
