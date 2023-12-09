#!mainFile "../../../main.opy"


rule "[sojourn/init.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.call_init

    defaultHero()
    eventPlayer.call_init = false
