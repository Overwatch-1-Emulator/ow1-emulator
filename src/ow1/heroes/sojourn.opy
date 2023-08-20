#!mainFile "../../main.opy"

rule "[sojourn.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization
