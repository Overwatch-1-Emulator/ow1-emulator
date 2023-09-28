#!mainFile "../../../main.opy"


rule "[junkerqueen/init.opy]: Initialize Junkerqueen":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.call_init
    
    resetHero()
    setCustomHealth(OW1_JUNKERQUEEN_HEALTH, 0, 0)
    # removeTankPassive()
    eventPlayer.call_init = false
