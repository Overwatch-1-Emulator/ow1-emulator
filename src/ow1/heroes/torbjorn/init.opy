#!mainFile "../../../main.opy"


rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.call_init

    resetHero()
    setCustomHealth(OW1_TORBJORN_HEALTH, OW1_TORBJORN_ARMOR, 0)
    eventPlayer.call_init = false


rule "[torbjorn.opy]: Correct overload hp":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    damage(eventPlayer, null, OW1_TORBJORN_OVERLOAD_OVERHEALTH*(OW1_TORBJORN_TURRET_HEALTH/OW2_TORBJORN_TURRET_HEALTH) - OW1_TORBJORN_OVERLOAD_OVERHEALTH)
