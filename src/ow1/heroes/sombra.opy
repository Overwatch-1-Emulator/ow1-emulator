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


rule "[sombra.opy]: No hack while invis":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)
    @Condition eventPlayer.enemy_sombra.isUsingAbility1() == true
    @Condition eventPlayer.enemy_sombra.isUsingUltimate() == false

    eventPlayer.enemy_sombra.cancelPrimaryAction()
    eventPlayer.enemy_sombra.setAbility1Enabled(false)
    eventPlayer.enemy_sombra.setAbility1Enabled(true)
