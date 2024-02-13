#!mainFile "../../main.opy"


rule "[torbjorn/init.opy]: Detect switch to Torbjorn":
    @Event eachPlayer
    @Hero torbjorn

    eventPlayer.call_init = true


rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.call_init

    newHero(OW1_TORBJORN_HEALTH, OW1_TORBJORN_ARMOR, 0)
    setUltCost(OW1_TORBJORN_ULT_COST)
    removeSelfHealing()

    eventPlayer.call_init = false


rule "[torbjorn.opy]: Correct overload hp":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2()

    damage(eventPlayer, null, OW1_TORBJORN_OVERLOAD_OVERHEALTH*(OW1_TORBJORN_TURRET_HEALTH/OW2_TORBJORN_TURRET_HEALTH) - OW1_TORBJORN_OVERLOAD_OVERHEALTH)
