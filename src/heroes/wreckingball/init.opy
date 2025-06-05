#!mainFile "../../dev_main.opy"

#!include "grapple.opy"
#!include "adaptive_shield.opy"


def initHammond():
    @Name "[wreckingball/init.opy]: initHammond()"

    setCustomHp(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    setUltCost(OW1_WRECKING_BALL_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_WRECKING_BALL_MINEFIELD_DAMAGE/OW2_WRECKING_BALL_MINEFIELD_DAMAGE)





rule "[wreckingball/init.opy]: Correct primary fire, fireball, piledriver damage":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.CROUCH]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
