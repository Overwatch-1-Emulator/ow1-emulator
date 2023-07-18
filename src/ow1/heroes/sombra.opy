#!mainFile "../../main.opy"

playervar enemysombra
playervar friendlysombra

subroutine initSombra

rule "[sombra.opy]: Detect Sombra initialization":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization
    
    initSombra()
    eventPlayer.initialized = true


def initSombra():
    @Name "[sombra.opy]: initSombra()"

    getPlayers(eventPlayer.getTeam()).friendlysombra = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemysombra = eventPlayer


rule "[sombra.opy]: No hack while invis":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)
    @Condition eventPlayer.enemysombra.isUsingAbility1() == true
    @Condition eventPlayer.enemysombra.isUsingUltimate() == false

    eventPlayer.enemysombra.cancelPrimaryAction()
    eventPlayer.enemysombra.setAbility1Enabled(false)
    eventPlayer.enemysombra.setAbility1Enabled(true)
