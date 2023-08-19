#!mainFile "../../main.opy"

subroutine initWreckingball

rule "[wreckingball.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initWreckingball()
    eventPlayer.initialized = true


def initWreckingball():
    @Name "[wreckingball.opy]: initWreckingball()"

    while (eventPlayer.getMaxHealth() != OW1_WRECKING_BALL_HEALTH + OW1_WRECKING_BALL_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
        wait(1)
    
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))