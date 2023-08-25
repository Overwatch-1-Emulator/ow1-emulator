#!mainFile "../../main.opy"

rule "[pharah.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization
