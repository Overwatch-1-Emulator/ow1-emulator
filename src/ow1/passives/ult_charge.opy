#!mainFile "../../main.opy"

# Global variables
globalvar ult_cost

# Player variables
playervar ult_charge_pvar
#!defineMember missing_ult_points ult_charge_pvar[0]
#!defineMember ult_percent_compensated ult_charge_pvar[1]
#!defineMember ult_charge_compensated ult_charge_pvar[2]

subroutine resetUltCharge


rule "[ult_charge.opy]: initialize overwatch 1 ultimate costs":
    # Tanks
    ult_cost[heroID(Hero.DVA)] = OW1_DVA_ULT_COST
    ult_cost[heroID(Hero.JUNKER_QUEEN)] = OW1_JUNKERQUEEN_ULT_COST
    ult_cost[heroID(Hero.ORISA)] = OW1_ORISA_ULT_COST
    ult_cost[heroID(Hero.RAMATTRA)] = OW1_RAMATTRA_ULT_COST
    ult_cost[heroID(Hero.REINHARDT)] = OW1_REINHARDT_ULT_COST
    ult_cost[heroID(Hero.ROADHOG)] = OW1_ROADHOG_ULT_COST
    ult_cost[heroID(Hero.SIGMA)] = OW1_SIGMA_ULT_COST
    ult_cost[heroID(Hero.WINSTON)] = OW1_WINSTON_ULT_COST
    ult_cost[heroID(Hero.HAMMOND)] = OW1_WRECKING_BALL_ULT_COST
    ult_cost[heroID(Hero.ZARYA)] = OW1_ZARYA_ULT_COST

    # Damages
    ult_cost[heroID(Hero.ASHE)] = OW1_ASHE_ULT_COST
    ult_cost[heroID(Hero.BASTION)] = OW1_BASTION_ULT_COST
    ult_cost[heroID(Hero.DOOMFIST)] = OW1_DOOMFIST_ULT_COST
    ult_cost[heroID(Hero.MCCREE)] = OW1_MCCREE_ULT_COST
    ult_cost[heroID(Hero.ECHO)] = OW1_ECHO_ULT_COST
    ult_cost[heroID(Hero.GENJI)] = OW1_GENJI_ULT_COST
    ult_cost[heroID(Hero.HANZO)] = OW1_HANZO_ULT_COST
    ult_cost[heroID(Hero.JUNKRAT)] = OW1_JUNKRAT_ULT_COST
    ult_cost[heroID(Hero.MEI)] = OW1_MEI_ULT_COST
    ult_cost[heroID(Hero.PHARAH)] = OW1_PHARAH_ULT_COST
    ult_cost[heroID(Hero.REAPER)] = OW1_REAPER_ULT_COST
    ult_cost[heroID(Hero.SOJOURN)] = OW1_SOJOURN_ULT_COST
    ult_cost[heroID(Hero.SOLDIER)] = OW1_SOLDIER_ULT_COST
    ult_cost[heroID(Hero.SOMBRA)] = OW1_SOMBRA_ULT_COST
    ult_cost[heroID(Hero.SYMMETRA)] = OW1_SYMMETRA_ULT_COST
    ult_cost[heroID(Hero.TORBJORN)] = OW1_TORBJORN_ULT_COST
    ult_cost[heroID(Hero.TRACER)] = OW1_TRACER_ULT_COST
    ult_cost[heroID(Hero.WIDOWMAKER)] = OW1_WIDOWMAKER_ULT_COST

    # Supports
    ult_cost[heroID(Hero.ANA)] = OW1_ANA_ULT_COST
    ult_cost[heroID(Hero.BAPTISTE)] = OW1_BAPTISTE_ULT_COST
    ult_cost[heroID(Hero.BRIGITTE)] = OW1_BRIGITTE_ULT_COST
    ult_cost[heroID(Hero.ILLARI)] = OW1_ILLARI_ULT_COST
    ult_cost[heroID(Hero.KIRIKO)] = OW1_KIRIKO_ULT_COST
    ult_cost[heroID(Hero.LIFEWEAVER)] = OW1_LIFEWEAVER_ULT_COST
    ult_cost[heroID(Hero.LUCIO)] = OW1_LUCIO_ULT_COST
    ult_cost[heroID(Hero.MERCY)] = OW1_MERCY_ULT_COST
    ult_cost[heroID(Hero.MOIRA)] = OW1_MOIRA_ULT_COST
    ult_cost[heroID(Hero.ZENYATTA)] = OW1_ZENYATTA_ULT_COST


def resetUltCharge():
    @Name "[ult_charge.opy]: resetUltCharge()"

    eventPlayer.missing_ult_points = 0
    eventPlayer.ult_percent_compensated = 0
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

    eventPlayer.ult_percent_compensated = percent(eventPlayer.missing_ult_points/ult_cost[eventPlayer.hero_id]) + 3 # add 3% extra to compensate for rounding error
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventPlayer.ult_percent_compensated)
    eventPlayer.ult_charge_compensated = percentOf(eventPlayer.ult_percent_compensated, ult_cost[eventPlayer.hero_id])
    eventPlayer.missing_ult_points -= eventPlayer.ult_charge_compensated


rule "[ult_charge.opy]: Reset ult compensation after using ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points = 0
    eventPlayer.ult_percent_compensated = 0
