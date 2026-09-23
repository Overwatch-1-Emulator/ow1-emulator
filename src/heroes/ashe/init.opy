#!mainFile "../../main.opy"

#!include "bob.opy"
#!include "viper.opy"


def initAshe():
    @Name "[ashe/init.opy]: initAshe()"

    setCustomHp(OW1_ASHE_HEALTH, 0, 0)
    setUltCost(OW1_ASHE_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)



rule "[ashe/init.opy]: Compensate Ashe global damage reduction":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]
    @Condition not eventPlayer.isFiringSecondaryFire()

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[ashe/init.opy]: Compensate Ashe global armor reduction":
    @Event playerDealtDamage
    @Hero pharah
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition victim.getHealthOfType(Health.ARMOR) > 0
    @Condition getTempShields(victim) == 0

    damage(victim, attacker, ow2ArmorRawFor(ow1ArmorApplied(ow2ArmorRawFor(eventDamage)/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
