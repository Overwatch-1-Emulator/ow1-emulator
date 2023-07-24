#!mainFile "../../main.opy"

playervar enemy_sombra
playervar friendly_sombra

subroutine initSombra

rule "[sombra.opy]: Detect Sombra initialization":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSombra()
    eventPlayer.initialized = true


def initSombra():
    @Name "[sombra.opy]: initSombra()"

    getPlayers(eventPlayer.getTeam()).friendly_sombra = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_sombra = eventPlayer


rule "[sombra.opy]: Cancel invis if hack activated":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isFiringSecondaryFire()
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)

rule "[sombra.opy]: Set hack cooldown time after being damaged while hacking":
    @Event playerTookDamage
    @Hero sombra
    @Condition eventPlayer.isFiringSecondaryFire() == true

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_SOMBRA_HACK_COOLDOWN_TIME_AFTER_INTERRUPT)

rule "[sombra.opy]: Set hack duration on heroes":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) == true

    wait(OW1_SOMBRA_HACK_DURATION_ON_ENEMIES)
    if eventPlayer.isAlive():
        respawnSameState()

rule "[sombra.opy]: Disable abilities on hacked enemies":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) == true

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)
    # Disables secondary fire on heroes that have a separate ability as secondary fire. Weapons should not be affected.
    if not eventPlayer.getCurrentHero() in [Hero.ANA, Hero.ASHE, Hero.BAPTISTE, Hero.MCCREE, Hero.GENJI, Hero.JUNKRAT, Hero.MEI, Hero.ROADHOG, Hero.SYMMETRA, Hero.TORBJORN, Hero.TRACER, Hero.WIDOWMAKER, Hero.ZARYA]:
        eventPlayer.setSecondaryFireEnabled(false)
    wait(OW1_SOMBRA_HACK_DURATION_ON_ENEMIES)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)