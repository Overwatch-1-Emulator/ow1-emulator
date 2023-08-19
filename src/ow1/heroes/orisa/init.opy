#!mainFile "../../../main.opy"

subroutine initOrisa

rule "[orisa/init.opy]: Initialize Orisa":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    wait() # Yield to other initialization rules
    
    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_orisa_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_orisa_player = eventPlayer

    eventPlayer.initialized = true
