#!mainFile "../../dev_main.opy"

#!include "heroes/torbjorn/overload.opy"


rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.TORBJORN
    @Condition eventPlayer._call_init

    setCustomHp(OW1_TORBJORN_HEALTH, OW1_TORBJORN_ARMOR, 0)
    setUltCost(OW1_TORBJORN_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_TORBJORN_TURRET_DAMAGE/OW2_TORBJORN_TURRET_DAMAGE)

    eventPlayer._call_init = false


rule "[torbjorn/init.opy]: Correct Rivet Gun, Hammer, and ultimate damage":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ULTIMATE]
    @Condition not eventPlayer.isInAlternateForm()

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


rule "[torbjorn/init.opy]: Increase Forge Hammer damage during overload":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isInAlternateForm()

    damage(
        victim, 
        attacker, 
        (((110/55) if eventPlayer.isUsingAbility2() else 1) * eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
