#!include "./utilities.opy"
#!include "./ow1_constants.opy"

# Global variables
globalvar ult_cost

# Player variables
playervar missing_ult_points
playervar ult_compensation

rule "initialize overwatch 1 ultimate costs":
    ult_cost[heroID(Hero.DVA)] = ow1_ult_cost_DVA
    ult_cost[heroID(Hero.REINHARDT)] = ow1_ult_cost_REINHARDT
    ult_cost[heroID(Hero.ROADHOG)] = ow1_ult_cost_ROADHOG
    ult_cost[heroID(Hero.SIGMA)] = ow1_ult_cost_SIGMA
    ult_cost[heroID(Hero.WINSTON)] = ow1_ult_cost_WINSTON
    ult_cost[heroID(Hero.HAMMOND)] = ow1_ult_cost_HAMMOND
    ult_cost[heroID(Hero.ZARYA)] = ow1_ult_cost_ZARYA
    ult_cost[heroID(Hero.ASHE)] = ow1_ult_cost_ASHE
    ult_cost[heroID(Hero.BASTION)] = ow1_ult_cost_BASTION
    ult_cost[heroID(Hero.MCCREE)] = ow1_ult_cost_MCCREE
    ult_cost[heroID(Hero.ECHO)] = ow1_ult_cost_ECHO
    ult_cost[heroID(Hero.GENJI)] = ow1_ult_cost_GENJI
    ult_cost[heroID(Hero.HANZO)] = ow1_ult_cost_HANZO
    ult_cost[heroID(Hero.JUNKRAT)] = ow1_ult_cost_JUNKRAT
    ult_cost[heroID(Hero.MEI)] = ow1_ult_cost_MEI
    ult_cost[heroID(Hero.PHARAH)] = ow1_ult_cost_PHARAH
    ult_cost[heroID(Hero.REAPER)] = ow1_ult_cost_REAPER
    ult_cost[heroID(Hero.SOLDIER)] = ow1_ult_cost_SOLDIER
    ult_cost[heroID(Hero.SOMBRA)] = ow1_ult_cost_SOMBRA
    ult_cost[heroID(Hero.SYMMETRA)] = ow1_ult_cost_SYMMETRA
    ult_cost[heroID(Hero.TORBJORN)] = ow1_ult_cost_TORBJORN
    ult_cost[heroID(Hero.TRACER)] = ow1_ult_cost_TRACER
    ult_cost[heroID(Hero.WIDOWMAKER)] = ow1_ult_cost_WIDOWMAKER
    ult_cost[heroID(Hero.ANA)] = ow1_ult_cost_ANA
    ult_cost[heroID(Hero.BAPTISTE)] = ow1_ult_cost_BAPTISTE
    ult_cost[heroID(Hero.BRIGITTE)] = ow1_ult_cost_BRIGITTE
    ult_cost[heroID(Hero.LUCIO)] = ow1_ult_cost_LUCIO
    ult_cost[heroID(Hero.MERCY)] = ow1_ult_cost_MERCY
    ult_cost[heroID(Hero.MOIRA)] = ow1_ult_cost_MOIRA
    ult_cost[heroID(Hero.ZENYATTA)] = ow1_ult_cost_ZENYATTA

rule "Remember missing ult charge from damaging tank":
    @Event playerDealtDamage
    @Condition victim != eventPlayer
    @Condition any([victim.getCurrentHero() == tank_hero for tank_hero in getTankHeroes()])

    eventPlayer.missing_ult_points += 0.3*eventDamage

rule "Remember missing ult charge from healing tank":
    @Event playerDealtHealing
    @Condition any([healee.getCurrentHero() == tank_hero for tank_hero in getTankHeroes()])

    eventPlayer.missing_ult_points += 0.3*eventHealing

rule "Compensate missing ult charge":
    @Event eachPlayer
    @Condition eventPlayer.missing_ult_points/ult_cost[heroID(eventPlayer.getCurrentHero())] >= 0.01

    do:
        eventPlayer.ult_compensation = percent(eventPlayer.missing_ult_points/ult_cost[heroID(eventPlayer.getCurrentHero())])
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventPlayer.ult_compensation)
        eventPlayer.missing_ult_points = eventPlayer.missing_ult_points - round(eventPlayer.ult_compensation)/100*ult_cost[heroID(eventPlayer.getCurrentHero())]
    while (RULE_CONDITION)

rule "Reset ult compensation after using ult or switching hero":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() or eventPlayer.hero_switched

    eventPlayer.missing_ult_points = 0
    eventPlayer.ult_compensation = 0

rule "Reset ult charge on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched

    wait()
    eventPlayer.setUltCharge(0)
