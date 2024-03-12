#!mainFile "../../main.opy"


rule "[torbjorn/turret.opy]: OW1 Turret damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility == Button.ABILITY_1

    heal(victim, null, eventDamage - (OW1_TORBJORN_TURRET_DAMAGE/OW2_TORBJORN_TURRET_DAMAGE) * eventDamage)
