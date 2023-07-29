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
