#!mainFile "../../ow1pp_main.opy"

#!include "heroes/illari/sun.opy"
#!include "heroes/illari/solar_rifle.opy"


rule "[illari/init.opy]: Detect switch to Illari":
    @Event eachPlayer
    @Hero illari

    eventPlayer.call_init = true


rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.call_init
    
    newHero(OW1_ILLARI_HEALTH, 0, 0)
    setUltCost(OW1_ILLARI_ULT_COST)
    removePassiveHealing()

    setBaseDamage(eventPlayer, OW1_ILLARI_SUNSTRUCK_DAMAGE/OW2_ILLARI_SUNSTRUCK_DAMAGE)

    eventPlayer.call_init = false


rule "[illari/init.opy]: Correct Outburst damage":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
