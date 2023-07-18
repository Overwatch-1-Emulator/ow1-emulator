#!mainFile "../../main.opy"
playervar enemysombra
playervar friendlysombra

subroutine initSombra

def initSombra():
    getPlayers(eventPlayer.getTeam()).friendlysombra = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemysombra = eventPlayer
    pass

rule "[sombra.opy]: Initialize Sombra":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSombra()
    eventPlayer.initialized = true
        
rule "[sombra.opy]: No hack while invis":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    if eventPlayer.enemysombra.isUsingAbility1() == true and eventPlayer.enemysombra.isUsingUltimate() == false:
        eventPlayer.enemysombra.cancelPrimaryAction()
        eventPlayer.enemysombra.setAbility1Enabled(false)
        eventPlayer.enemysombra.setAbility1Enabled(true)

        
