#!mainFile "../../dev_main.opy"

#!include "heroes/wreckingball/grapple.opy"
#!include "heroes/wreckingball/adaptive_shield.opy"


rule "[wreckingball/init.opy]: Initialize Wrecking Ball":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.HAMMOND
    @Condition eventPlayer._call_init

    setCustomHp(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    setUltCost(OW1_WRECKING_BALL_ULT_COST)
    removeTankPassive()
    removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_WRECKING_BALL_MINEFIELD_DAMAGE/OW2_WRECKING_BALL_MINEFIELD_DAMAGE)

    eventPlayer._call_init = false


rule "[wreckingball/init.opy]: Correct primary fire, fireball, piledriver damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.HAMMOND
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.CROUCH]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
