#!mainFile "../../main.opy"

#!define OW1_TANK_ULT_NEGATION_PERCENT_DEFAULT 0
#!define OW1_OVERHEALTH_ULT_CHARGE_REDUCTION 0
#!define OW1_ROADHOG_ULT_CHARGE_REDUCTION 25
globalvar OW1_TANK_ULT_NEGATION_PERCENT = createWorkshopSetting(int[0:OW2_TANK_ULT_NEGATION_PERCENT], 'Passive', 'Tank - Ultimate Charge Negation Percent', OW1_TANK_ULT_NEGATION_PERCENT_DEFAULT)

# Player variables
playervar ult_charge_pvar
#!defineMember _missing_ult_points ult_charge_pvar[0]
#!defineMember _ult_cost ult_charge_pvar[1]
#!defineMember _new_ult_percent ult_charge_pvar[2]
#!defineMember _roadhog_excess_ult_points ult_charge_pvar[3]

macro getUltPoints(player):
    percentOf(player.getUltCharge(), player._ult_cost)

macro setUltCost(cost):
    eventPlayer._ult_cost = cost


def resetUltCharge():
    @Name "[passives/tank/ult_charge.opy]: resetUltCharge()"

    eventPlayer._ult_charge_reset = false

    eventPlayer._missing_ult_points = 0
    eventPlayer._ult_cost = 0
    waitUntil(eventPlayer.getUltCharge() > 0, 1)
    eventPlayer.setUltCharge(0)

    eventPlayer._ult_charge_reset = true


#rule "[passives/tank/ult_charge.opy]: Remember missing ult charge from damaging tank":
#    @Event playerDealtDamage
#    @Condition victim.getCurrentHero() in getTankHeroes()
#    @Condition not eventPlayer.isUsingUltimate()
#    @Condition victim != eventPlayer

#    eventPlayer._missing_ult_points += unpercent(OW2_TANK_ULT_NEGATION_PERCENT - OW1_TANK_ULT_NEGATION_PERCENT) * eventDamage


#rule "[passives/tank/ult_charge.opy]: Remember missing ult charge from healing tank":
#    @Event playerDealtHealing
#    @Condition healee.getCurrentHero() in getTankHeroes()
#    @Condition not eventPlayer.isUsingUltimate()

#    eventPlayer._missing_ult_points += unpercent(OW2_TANK_ULT_NEGATION_PERCENT - OW1_TANK_ULT_NEGATION_PERCENT) * eventHealing



rule "[roadhog/passive.opy]: Track excess ult charge from damaging Roadhog":
    @Event playerDealtDamage
    @Condition victim.getCurrentHero() == Hero.ROADHOG
    @Condition victim != eventPlayer
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer._roadhog_excess_ult_points += unpercent(OW1_ROADHOG_ULT_CHARGE_REDUCTION) * eventDamage


rule "[roadhog/passive.opy]: Claw back excess ultimate percentage":
    @Event eachPlayer
    @Condition eventPlayer._roadhog_excess_ult_points > percentOf(1, eventPlayer._ult_cost)
    @Condition eventPlayer._ult_cost > 0

    eventPlayer._new_ult_percent = floor(percent((getUltPoints(eventPlayer) - eventPlayer._roadhog_excess_ult_points)/eventPlayer._ult_cost))
    eventPlayer._roadhog_excess_ult_points -= getUltPoints(eventPlayer) - percentOf(eventPlayer._new_ult_percent, eventPlayer._ult_cost)
    eventPlayer.setUltCharge(eventPlayer._new_ult_percent)




rule "[passives/tank/ult_charge.opy]: Remember missing ult charge from damaging overhealth":
    @Event playerDealtDamage
    @Condition victim.getMaxHealth() - victim.getMaxHealthOfType(Health.NORMAL) - victim.getMaxHealthOfType(Health.ARMOR) - victim.getMaxHealthOfType(Health.SHIELDS) > 0
    @Condition not eventPlayer.isUsingUltimate()
    @Condition victim != eventPlayer

    eventPlayer._missing_ult_points += unpercent(OW2_OVERHEALTH_ULT_CHARGE_REDUCTION - OW1_OVERHEALTH_ULT_CHARGE_REDUCTION) * min(eventDamage, victim.getMaxHealth() - victim.getMaxHealthOfType(Health.NORMAL) - victim.getMaxHealthOfType(Health.ARMOR) - victim.getMaxHealthOfType(Health.SHIELDS))

    
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
    eventPlayer._roadhog_excess_ult_points = 0
