#!mainFile "../../main.opy"

rule "[ramattra.opy]: Initialize Ramattra":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    setCustomHealth(OW1_RAMATTRA_HEALTH, 0, 0)

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
