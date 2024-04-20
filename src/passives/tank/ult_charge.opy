#!mainFile "../../main.opy"

# Player variables
playervar ult_charge_pvar
#!defineMember _missing_ult_points ult_charge_pvar[0]
#!defineMember _ult_cost ult_charge_pvar[1]
#!defineMember _new_ult_percent ult_charge_pvar[2]

#!define getUltPoints(player)\
    (percentOf(player.getUltCharge(), player._ult_cost))

#!define setUltCost(cost)\
    (eventPlayer._ult_cost = cost)

#!define resetUltCharge()\
    eventPlayer._missing_ult_points = 0\
    eventPlayer._ult_cost = 0\
    waitUntil(eventPlayer.getUltCharge() > 0, 1)\
    eventPlayer.setUltCharge(0)


rule "[passives/tank/ult_charge.opy]: Remember missing ult charge from damaging tank":
    @Event playerDealtDamage
    @Condition victim.getCurrentHero() in getTankHeroes()
    @Condition victim.getCurrentHero() not in [Hero.ROADHOG] # Roadhog passive
    @Condition not eventPlayer.isUsingUltimate()
    @Condition victim != eventPlayer

    eventPlayer._missing_ult_points += OW2_TANK_ULT_NEGATION * eventDamage


rule "[passives/tank/ult_charge.opy]: Remember missing ult charge from healing tank":
    @Event playerDealtHealing
    @Condition healee.getCurrentHero() in getTankHeroes()
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer._missing_ult_points += OW2_TANK_ULT_NEGATION * eventHealing


rule "[passives/tank/ult_charge.opy]: Compensate missing ultimate percentage":
    @Event eachPlayer
    @Condition eventPlayer._missing_ult_points > percentOf(1, eventPlayer._ult_cost)
    @Condition eventPlayer._ult_cost > 0 # guard to protect ult resetting accidentally

    eventPlayer._new_ult_percent = ceil(percent((getUltPoints(eventPlayer) + eventPlayer._missing_ult_points)/eventPlayer._ult_cost))
    eventPlayer._missing_ult_points -= percentOf(eventPlayer._new_ult_percent, eventPlayer._ult_cost) - getUltPoints(eventPlayer)
    eventPlayer.setUltCharge(eventPlayer._new_ult_percent)


rule "[passives/tank/ult_charge.opy]: Reset ult compensation after using ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer._missing_ult_points = 0
