#!mainFile "../../dev_main.opy"

#!include "heroes/illari/sun.opy"
#!include "heroes/illari/solar_rifle.opy"


rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.ILLARI
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_ILLARI_HEALTH, 0, 0)
    setUltCost(OW1_ILLARI_ULT_COST)

    removePassiveHealing()

    setBaseDamage(eventPlayer, OW1_ILLARI_SUNSTRUCK_DAMAGE/OW2_ILLARI_SUNSTRUCK_DAMAGE)

    eventPlayer._call_init = false


rule "[illari/init.opy]: Correct Outburst damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.ILLARI
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
