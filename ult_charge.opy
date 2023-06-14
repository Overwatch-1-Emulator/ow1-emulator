#!include "./utilities.opy"
#!include "./constants.opy"

# Global variables
globalvar ow1_ult_cost
globalvar ow2_ult_cost

# Player variables
playervar missing_ult_points
playervar ult_compensation

rule "initialize overwatch 1 ultimate costs":
    ow1_ult_cost[heroID(Hero.DVA)] = ow1_ult_cost_DVA
    ow1_ult_cost[heroID(Hero.REINHARDT)] = ow1_ult_cost_REINHARDT
    ow1_ult_cost[heroID(Hero.ROADHOG)] = ow1_ult_cost_ROADHOG
    ow1_ult_cost[heroID(Hero.SIGMA)] = ow1_ult_cost_SIGMA
    ow1_ult_cost[heroID(Hero.WINSTON)] = ow1_ult_cost_WINSTON
    ow1_ult_cost[heroID(Hero.HAMMOND)] = ow1_ult_cost_HAMMOND
    ow1_ult_cost[heroID(Hero.ZARYA)] = ow1_ult_cost_ZARYA
    ow1_ult_cost[heroID(Hero.ASHE)] = ow1_ult_cost_ASHE
    ow1_ult_cost[heroID(Hero.BASTION)] = ow1_ult_cost_BASTION
    ow1_ult_cost[heroID(Hero.MCCREE)] = ow1_ult_cost_MCCREE
    ow1_ult_cost[heroID(Hero.ECHO)] = ow1_ult_cost_ECHO
    ow1_ult_cost[heroID(Hero.GENJI)] = ow1_ult_cost_GENJI
    ow1_ult_cost[heroID(Hero.HANZO)] = ow1_ult_cost_HANZO
    ow1_ult_cost[heroID(Hero.JUNKRAT)] = ow1_ult_cost_JUNKRAT
    ow1_ult_cost[heroID(Hero.MEI)] = ow1_ult_cost_MEI
    ow1_ult_cost[heroID(Hero.PHARAH)] = ow1_ult_cost_PHARAH
    ow1_ult_cost[heroID(Hero.REAPER)] = ow1_ult_cost_REAPER
    ow1_ult_cost[heroID(Hero.SOLDIER)] = ow1_ult_cost_SOLDIER
    ow1_ult_cost[heroID(Hero.SOMBRA)] = ow1_ult_cost_SOMBRA
    ow1_ult_cost[heroID(Hero.SYMMETRA)] = ow1_ult_cost_SYMMETRA
    ow1_ult_cost[heroID(Hero.TORBJORN)] = ow1_ult_cost_TORBJORN
    ow1_ult_cost[heroID(Hero.TRACER)] = ow1_ult_cost_TRACER
    ow1_ult_cost[heroID(Hero.WIDOWMAKER)] = ow1_ult_cost_WIDOWMAKER
    ow1_ult_cost[heroID(Hero.ANA)] = ow1_ult_cost_ANA
    ow1_ult_cost[heroID(Hero.BAPTISTE)] = ow1_ult_cost_BAPTISTE
    ow1_ult_cost[heroID(Hero.BRIGITTE)] = ow1_ult_cost_BRIGITTE
    ow1_ult_cost[heroID(Hero.LUCIO)] = ow1_ult_cost_LUCIO
    ow1_ult_cost[heroID(Hero.MERCY)] = ow1_ult_cost_MERCY
    ow1_ult_cost[heroID(Hero.MOIRA)] = ow1_ult_cost_MOIRA
    ow1_ult_cost[heroID(Hero.ZENYATTA)] = ow1_ult_cost_ZENYATTA


rule "initialize overwatch 1 ultimate costs":
    ow2_ult_cost[heroID(Hero.DVA)] = ow2_ult_cost_DVA
    ow2_ult_cost[heroID(Hero.REINHARDT)] = ow2_ult_cost_REINHARDT
    ow2_ult_cost[heroID(Hero.ROADHOG)] = ow2_ult_cost_ROADHOG
    ow2_ult_cost[heroID(Hero.SIGMA)] = ow2_ult_cost_SIGMA
    ow2_ult_cost[heroID(Hero.WINSTON)] = ow2_ult_cost_WINSTON
    ow2_ult_cost[heroID(Hero.HAMMOND)] = ow2_ult_cost_HAMMOND
    ow2_ult_cost[heroID(Hero.ZARYA)] = ow2_ult_cost_ZARYA
    ow2_ult_cost[heroID(Hero.ASHE)] = ow2_ult_cost_ASHE
    ow2_ult_cost[heroID(Hero.BASTION)] = ow2_ult_cost_BASTION
    ow2_ult_cost[heroID(Hero.MCCREE)] = ow2_ult_cost_MCCREE
    ow2_ult_cost[heroID(Hero.ECHO)] = ow2_ult_cost_ECHO
    ow2_ult_cost[heroID(Hero.GENJI)] = ow2_ult_cost_GENJI
    ow2_ult_cost[heroID(Hero.HANZO)] = ow2_ult_cost_HANZO
    ow2_ult_cost[heroID(Hero.JUNKRAT)] = ow2_ult_cost_JUNKRAT
    ow2_ult_cost[heroID(Hero.MEI)] = ow2_ult_cost_MEI
    ow2_ult_cost[heroID(Hero.PHARAH)] = ow2_ult_cost_PHARAH
    ow2_ult_cost[heroID(Hero.REAPER)] = ow2_ult_cost_REAPER
    ow2_ult_cost[heroID(Hero.SOLDIER)] = ow2_ult_cost_SOLDIER
    ow2_ult_cost[heroID(Hero.SOMBRA)] = ow2_ult_cost_SOMBRA
    ow2_ult_cost[heroID(Hero.SYMMETRA)] = ow2_ult_cost_SYMMETRA
    ow2_ult_cost[heroID(Hero.TORBJORN)] = ow2_ult_cost_TORBJORN
    ow2_ult_cost[heroID(Hero.TRACER)] = ow2_ult_cost_TRACER
    ow2_ult_cost[heroID(Hero.WIDOWMAKER)] = ow2_ult_cost_WIDOWMAKER
    ow2_ult_cost[heroID(Hero.ANA)] = ow2_ult_cost_ANA
    ow2_ult_cost[heroID(Hero.BAPTISTE)] = ow2_ult_cost_BAPTISTE
    ow2_ult_cost[heroID(Hero.BRIGITTE)] = ow2_ult_cost_BRIGITTE
    ow2_ult_cost[heroID(Hero.LUCIO)] = ow2_ult_cost_LUCIO
    ow2_ult_cost[heroID(Hero.MERCY)] = ow2_ult_cost_MERCY
    ow2_ult_cost[heroID(Hero.MOIRA)] = ow2_ult_cost_MOIRA
    ow2_ult_cost[heroID(Hero.ZENYATTA)] = ow2_ult_cost_ZENYATTA

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
    @Condition eventPlayer.missing_ult_points/ow1_ult_cost[heroID(eventPlayer.getCurrentHero())] >= 0.01

    do:
        eventPlayer.ult_compensation = percent(eventPlayer.missing_ult_points/ow1_ult_cost[heroID(eventPlayer.getCurrentHero())])
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventPlayer.ult_compensation)
        eventPlayer.missing_ult_points = eventPlayer.missing_ult_points - round(eventPlayer.ult_compensation)/100*ow1_ult_cost[heroID(eventPlayer.getCurrentHero())]
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
