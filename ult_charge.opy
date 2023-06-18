#!include "./utilities.opy"
#!include "./ow1_constants.opy"
#!include "./ow2_constants.opy"

# Global variables
globalvar ult_cost

# Player variables
playervar missing_ult_points
playervar ult_percent_compensated
playervar ult_charge_compensated

rule "initialize overwatch 1 ultimate costs":
    ult_cost[heroID(Hero.DVA)] = percentOf(roundedPercent(ow1_ult_cost_DVA/ow2_ult_cost_DVA), ow2_ult_cost_DVA)
    ult_cost[heroID(Hero.REINHARDT)] = percentOf(roundedPercent(ow1_ult_cost_REINHARDT/ow2_ult_cost_REINHARDT), ow2_ult_cost_REINHARDT)
    ult_cost[heroID(Hero.ROADHOG)] = percentOf(roundedPercent(ow1_ult_cost_ROADHOG/ow2_ult_cost_ROADHOG), ow2_ult_cost_ROADHOG)
    ult_cost[heroID(Hero.SIGMA)] = percentOf(roundedPercent(ow1_ult_cost_SIGMA/ow2_ult_cost_SIGMA), ow2_ult_cost_SIGMA)
    ult_cost[heroID(Hero.WINSTON)] = percentOf(roundedPercent(ow1_ult_cost_WINSTON/ow2_ult_cost_WINSTON), ow2_ult_cost_WINSTON)
    ult_cost[heroID(Hero.HAMMOND)] = percentOf(roundedPercent(ow1_ult_cost_HAMMOND/ow2_ult_cost_HAMMOND), ow2_ult_cost_HAMMOND)
    ult_cost[heroID(Hero.ZARYA)] = percentOf(roundedPercent(ow1_ult_cost_ZARYA/ow2_ult_cost_ZARYA), ow2_ult_cost_ZARYA)
    ult_cost[heroID(Hero.ASHE)] = percentOf(roundedPercent(ow1_ult_cost_ASHE/ow2_ult_cost_ASHE), ow2_ult_cost_ASHE)
    ult_cost[heroID(Hero.BASTION)] = percentOf(roundedPercent(ow1_ult_cost_BASTION/ow2_ult_cost_BASTION), ow2_ult_cost_BASTION)
    ult_cost[heroID(Hero.MCCREE)] = percentOf(roundedPercent(ow1_ult_cost_MCCREE/ow2_ult_cost_MCCREE), ow2_ult_cost_MCCREE)
    ult_cost[heroID(Hero.ECHO)] = percentOf(roundedPercent(ow1_ult_cost_ECHO/ow2_ult_cost_ECHO), ow2_ult_cost_ECHO)
    ult_cost[heroID(Hero.GENJI)] = percentOf(roundedPercent(ow1_ult_cost_GENJI/ow2_ult_cost_GENJI), ow2_ult_cost_GENJI)
    ult_cost[heroID(Hero.HANZO)] = percentOf(roundedPercent(ow1_ult_cost_HANZO/ow2_ult_cost_HANZO), ow2_ult_cost_HANZO)
    ult_cost[heroID(Hero.JUNKRAT)] = percentOf(roundedPercent(ow1_ult_cost_JUNKRAT/ow2_ult_cost_JUNKRAT), ow2_ult_cost_JUNKRAT)
    ult_cost[heroID(Hero.MEI)] = percentOf(roundedPercent(ow1_ult_cost_MEI/ow2_ult_cost_MEI), ow2_ult_cost_MEI)
    ult_cost[heroID(Hero.PHARAH)] = percentOf(roundedPercent(ow1_ult_cost_PHARAH/ow2_ult_cost_PHARAH), ow2_ult_cost_PHARAH)
    ult_cost[heroID(Hero.REAPER)] = percentOf(roundedPercent(ow1_ult_cost_REAPER/ow2_ult_cost_REAPER), ow2_ult_cost_REAPER)
    ult_cost[heroID(Hero.SOLDIER)] = percentOf(roundedPercent(ow1_ult_cost_SOLDIER/ow2_ult_cost_SOLDIER), ow2_ult_cost_SOLDIER)
    ult_cost[heroID(Hero.SOMBRA)] = percentOf(roundedPercent(ow1_ult_cost_SOMBRA/ow2_ult_cost_SOMBRA), ow2_ult_cost_SOMBRA)
    ult_cost[heroID(Hero.SYMMETRA)] = percentOf(roundedPercent(ow1_ult_cost_SYMMETRA/ow2_ult_cost_SYMMETRA), ow2_ult_cost_SYMMETRA)
    ult_cost[heroID(Hero.TORBJORN)] = percentOf(roundedPercent(ow1_ult_cost_TORBJORN/ow2_ult_cost_TORBJORN), ow2_ult_cost_TORBJORN)
    ult_cost[heroID(Hero.TRACER)] = percentOf(roundedPercent(ow1_ult_cost_TRACER/ow2_ult_cost_TRACER), ow2_ult_cost_TRACER)
    ult_cost[heroID(Hero.WIDOWMAKER)] = percentOf(roundedPercent(ow1_ult_cost_WIDOWMAKER/ow2_ult_cost_WIDOWMAKER), ow2_ult_cost_WIDOWMAKER)
    ult_cost[heroID(Hero.ANA)] = percentOf(roundedPercent(ow1_ult_cost_ANA/ow2_ult_cost_ANA), ow2_ult_cost_ANA)
    ult_cost[heroID(Hero.BAPTISTE)] = percentOf(roundedPercent(ow1_ult_cost_BAPTISTE/ow2_ult_cost_BAPTISTE), ow2_ult_cost_BAPTISTE)
    ult_cost[heroID(Hero.BRIGITTE)] = percentOf(roundedPercent(ow1_ult_cost_BRIGITTE/ow2_ult_cost_BRIGITTE), ow2_ult_cost_BRIGITTE)
    ult_cost[heroID(Hero.LUCIO)] = percentOf(roundedPercent(ow1_ult_cost_LUCIO/ow2_ult_cost_LUCIO), ow2_ult_cost_LUCIO)
    ult_cost[heroID(Hero.MERCY)] = percentOf(roundedPercent(ow1_ult_cost_MERCY/ow2_ult_cost_MERCY), ow2_ult_cost_MERCY)
    ult_cost[heroID(Hero.MOIRA)] = percentOf(roundedPercent(ow1_ult_cost_MOIRA/ow2_ult_cost_MOIRA), ow2_ult_cost_MOIRA)
    ult_cost[heroID(Hero.ZENYATTA)] = percentOf(roundedPercent(ow1_ult_cost_ZENYATTA/ow2_ult_cost_ZENYATTA), ow2_ult_cost_ZENYATTA)

rule "Remember missing ult charge from damaging tank":
    @Event playerDealtDamage
    @Condition victim != eventPlayer
    @Condition any([victim.getCurrentHero() == tank_hero for tank_hero in getTankHeroes()])
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points += 0.3*eventDamage

rule "Remember missing ult charge from healing tank":
    @Event playerDealtHealing
    @Condition any([healee.getCurrentHero() == tank_hero for tank_hero in getTankHeroes()])
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points += 0.3*eventHealing

rule "Compensate missing ult charge":
    @Event eachPlayer
    @Condition percent(eventPlayer.missing_ult_points/ult_cost[eventPlayer.hero_id]) >= 1

    do:
        eventPlayer.ult_percent_compensated = roundedPercent(eventPlayer.missing_ult_points/ult_cost[eventPlayer.hero_id])
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventPlayer.ult_percent_compensated)
        eventPlayer.ult_charge_compensated = percentOf(eventPlayer.ult_percent_compensated, ult_cost[eventPlayer.hero_id])
        eventPlayer.missing_ult_points -= eventPlayer.ult_charge_compensated
    while (RULE_CONDITION)

rule "Reset ult compensation after using ult or switching hero":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() or eventPlayer.hero_switched

    eventPlayer.missing_ult_points = 0
    eventPlayer.ult_percent_compensated = 0

rule "Reset ult charge on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched

    wait()
    eventPlayer.setUltCharge(0)
