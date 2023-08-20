#!mainFile "../../main.opy"

rule "[torbjorn.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    while (eventPlayer.getMaxHealth() != OW1_TORBJORN_HEALTH + OW1_TORBJORN_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_TORBJORN_HEALTH, OW1_TORBJORN_ARMOR, 0)
        wait(1)


rule "[torbjorn.opy]: Correct overload hp":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    damage(eventPlayer, null, OW1_TORBJORN_OVERLOAD_OVERHEALTH*(OW1_TORBJORN_TURRET_HEALTH/OW2_TORBJORN_TURRET_HEALTH) - OW1_TORBJORN_OVERLOAD_OVERHEALTH)
