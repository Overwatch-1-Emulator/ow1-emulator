#!mainFile "../../main.opy"

subroutine initRamattra

rule "[ramattra.opy]: Detect Ramattra initialization":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initRamattra()
    eventPlayer.call_init = false


def initRamattra():
    @Name "[ramattra.opy]: initRamattra()"

    while (eventPlayer.getMaxHealth() != OW1_RAMATTRA_HEALTH):
        clearCustomHealth()
        setCustomHealth(OW1_RAMATTRA_HEALTH, 0, 0)
        wait(1)

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))
