#!mainFile "../../../main.opy"


rule "[ramattra/init.opy]: Initialize Ramattra":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.call_init

    defaultHero()
    # setCustomHp(OW1_RAMATTRA_HEALTH, 0, 0)
    # removeTankPassive()
    eventPlayer.call_init = false
