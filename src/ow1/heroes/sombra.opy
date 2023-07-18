#!mainFile "../../main.opy"
playervar enemysombra
playervar friendlysombra

<<<<<<< Updated upstream
subroutine initSombra

rule "[sombra.opy]: Detect Sombra initialization":
=======
def initSombra():
    getPlayers(eventPlayer.getTeam()).friendlysombra = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemysombra = eventPlayer
    pass

rule "[sombra.opy]: Initialize Sombra":
>>>>>>> Stashed changes
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSombra()
    eventPlayer.initialized = true
<<<<<<< Updated upstream


def initSombra():
    @Name "[sombra.opy]: initSombra()"
    # [TODO]
    pass
=======
        
rule "[sombra.opy]: No hack while invis":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    if eventPlayer.enemysombra.isUsingAbility1() == true and eventPlayer.enemysombra.isUsingUltimate() == false:
        eventPlayer.enemysombra.cancelPrimaryAction()
        eventPlayer.enemysombra.setAbility1Enabled(false)
        eventPlayer.enemysombra.setAbility1Enabled(true)

        
>>>>>>> Stashed changes
