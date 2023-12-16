#!mainFile "../../main.opy"

# Player variables
playervar ult_charge_pvar
#!defineMember missing_ult_points ult_charge_pvar[0]
#!defineMember ult_percent_compensated ult_charge_pvar[1]
#!defineMember ult_charge_compensated ult_charge_pvar[2]
#!defineMember ult_cost ult_charge_pvar[3]

#!define setUltCost(cost) (eventPlayer.ult_cost = cost)
subroutine resetUltCharge


def resetUltCharge():
    @Name "[ult_charge.opy]: resetUltCharge()"

    eventPlayer.missing_ult_points = 0
    eventPlayer.ult_percent_compensated = 0
    eventPlayer.ult_charge_compensated = 0
    eventPlayer.ult_cost = 0
    waitUntil(eventPlayer.getUltCharge() > 0, 1)
    eventPlayer.setUltCharge(0)


rule "[ult_charge.opy]: Remember missing ult charge from damaging tank":
    @Event playerDealtDamage
    @Condition victim.getCurrentHero() in getTankHeroes()
    @Condition victim.getCurrentHero() not in [Hero.ROADHOG] # Roadhog passive
    @Condition not eventPlayer.isUsingUltimate()
    @Condition victim != eventPlayer

    eventPlayer.missing_ult_points += OW2_TANK_ULT_NEGATION * eventDamage


rule "[ult_charge.opy]: Remember missing ult charge from healing tank":
    @Event playerDealtHealing
    @Condition healee.getCurrentHero() in getTankHeroes()
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points += OW2_TANK_ULT_NEGATION * eventHealing


rule "[ult_charge.opy]: Compensate missing ultimate percentage":
    @Event eachPlayer
    @Condition eventPlayer.missing_ult_points > 0

    eventPlayer.ult_percent_compensated = percent(eventPlayer.missing_ult_points/eventPlayer.ult_cost) + 3 # add 3% extra to compensate for rounding error
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventPlayer.ult_percent_compensated)
    eventPlayer.ult_charge_compensated = percentOf(eventPlayer.ult_percent_compensated, eventPlayer.ult_cost)
    eventPlayer.missing_ult_points -= eventPlayer.ult_charge_compensated


rule "[ult_charge.opy]: Reset ult compensation after using ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points = 0
    eventPlayer.ult_percent_compensated = 0
