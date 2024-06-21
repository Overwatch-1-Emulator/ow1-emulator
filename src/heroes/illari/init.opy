#!mainFile "../../dev_main.opy"

#!include "heroes/illari/sun.opy"
#!include "heroes/illari/solar_rifle.opy"


def initIllari():
    @Name "[illari/init.opy]: initIllari()"
    
    setCustomHp(OW1_ILLARI_HEALTH, 0, 0)
    setUltCost(OW1_ILLARI_ULT_COST)

    removePassiveHealing()

    setBaseDamage(eventPlayer, OW1_ILLARI_SUNSTRUCK_DAMAGE/OW2_ILLARI_SUNSTRUCK_DAMAGE)


rule "[illari/init.opy]: Initialize Illari":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer._call_init

    initIllari()
    eventPlayer._call_init = false


rule "[illari/init.opy]: Correct Outburst damage":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


rule "[illari/init.opy]: Correct Pylon self healing":
    @Event playerDealtHealing
    @Hero illari
    @Condition healee == healer

    heal(healee, null, eventHealing/OW2_ILLARI_PYLON_SELF_HEAL - eventHealing)
