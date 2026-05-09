#!mainFile "../../main.opy"

#!include "grapple.opy"
#!include "adaptive_shield.opy"


def initHammond():
    @Name "[wreckingball/init.opy]: initHammond()"

    setCustomHp(OW1_WRECKING_BALL_HEALTH, OW1_WRECKING_BALL_ARMOR, 0)
    setUltCost(OW1_WRECKING_BALL_ULT_COST)
    # removeTankPassive()
    # removeSelfHealing()

    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    eventPlayer.disallowButton(Button.ULTIMATE)


rule "[wreckingball/init.opy]: Correct primary fire, fireball, piledriver damage":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.CROUCH]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

rule "[wreckingball/init.opy]: Deal Correct Minefield Damage":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility == Button.ULTIMATE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_WRECKING_BALL_MINEFIELD_DAMAGE/OW2_WRECKING_BALL_MINEFIELD_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

rule "[wreckingball/init.opy]: OW1 MineField Activation Time":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.getUltCharge() == 100
    @Condition not isCCd(eventPlayer)

    wait(OW2_WRECKING_BALL_MINEFIELD_ACTIVATION_TIME-OW1_WRECKING_BALL_MINEFIELD_ACTIVATION_TIME)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.ULTIMATE)