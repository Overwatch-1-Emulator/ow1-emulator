#!mainFile "../../../main.opy"


rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.call_init

    defaultHero()

    eventPlayer.call_init = false
