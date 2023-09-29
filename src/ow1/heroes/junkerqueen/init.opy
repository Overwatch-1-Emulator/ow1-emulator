#!mainFile "../../../main.opy"


rule "[junkerqueen/init.opy]: Initialize Junkerqueen":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.call_init
    
    resetHero()
    # removeTankPassive()
    eventPlayer.call_init = false
