#!mainFile "../../main.opy"

# Global variables
globalvar ult_cost

# Player variables
playervar missing_ult_points
playervar ult_percent_compensated
playervar ult_charge_compensated

rule "initialize overwatch 1 ultimate costs":
    ult_cost[heroID(Hero.DVA)] = 1/(roundedPercent(ow2_ult_cost_DVA/ow1_ult_cost_DVA)/100)*ow2_ult_cost_DVA
    ult_cost[heroID(Hero.REINHARDT)] = 1/(roundedPercent(ow2_ult_cost_REINHARDT/ow1_ult_cost_REINHARDT)/100)*ow2_ult_cost_REINHARDT
    ult_cost[heroID(Hero.ROADHOG)] = 1/(roundedPercent(ow2_ult_cost_ROADHOG/ow1_ult_cost_ROADHOG)/100)*ow2_ult_cost_ROADHOG
    ult_cost[heroID(Hero.SIGMA)] = 1/(roundedPercent(ow2_ult_cost_SIGMA/ow1_ult_cost_SIGMA)/100)*ow2_ult_cost_SIGMA
    ult_cost[heroID(Hero.WINSTON)] = 1/(roundedPercent(ow2_ult_cost_WINSTON/ow1_ult_cost_WINSTON)/100)*ow2_ult_cost_WINSTON
    ult_cost[heroID(Hero.HAMMOND)] = 1/(roundedPercent(ow2_ult_cost_HAMMOND/ow1_ult_cost_HAMMOND)/100)*ow2_ult_cost_HAMMOND
    ult_cost[heroID(Hero.ZARYA)] = 1/(roundedPercent(ow2_ult_cost_ZARYA/ow1_ult_cost_ZARYA)/100)*ow2_ult_cost_ZARYA
    ult_cost[heroID(Hero.ASHE)] = 1/(roundedPercent(ow2_ult_cost_ASHE/ow1_ult_cost_ASHE)/100)*ow2_ult_cost_ASHE
    ult_cost[heroID(Hero.BASTION)] = 1/(roundedPercent(ow2_ult_cost_BASTION/ow1_ult_cost_BASTION)/100)*ow2_ult_cost_BASTION
    ult_cost[heroID(Hero.MCCREE)] = 1/(roundedPercent(ow2_ult_cost_MCCREE/ow1_ult_cost_MCCREE)/100)*ow2_ult_cost_MCCREE
    ult_cost[heroID(Hero.ECHO)] = 1/(roundedPercent(ow2_ult_cost_ECHO/ow1_ult_cost_ECHO)/100)*ow2_ult_cost_ECHO
    ult_cost[heroID(Hero.GENJI)] = 1/(roundedPercent(ow2_ult_cost_GENJI/ow1_ult_cost_GENJI)/100)*ow2_ult_cost_GENJI
    ult_cost[heroID(Hero.HANZO)] = 1/(roundedPercent(ow2_ult_cost_HANZO/ow1_ult_cost_HANZO)/100)*ow2_ult_cost_HANZO
    ult_cost[heroID(Hero.JUNKRAT)] = 1/(roundedPercent(ow2_ult_cost_JUNKRAT/ow1_ult_cost_JUNKRAT)/100)*ow2_ult_cost_JUNKRAT
    ult_cost[heroID(Hero.MEI)] = 1/(roundedPercent(ow2_ult_cost_MEI/ow1_ult_cost_MEI)/100)*ow2_ult_cost_MEI
    ult_cost[heroID(Hero.PHARAH)] = 1/(roundedPercent(ow2_ult_cost_PHARAH/ow1_ult_cost_PHARAH)/100)*ow2_ult_cost_PHARAH
    ult_cost[heroID(Hero.REAPER)] = 1/(roundedPercent(ow2_ult_cost_REAPER/ow1_ult_cost_REAPER)/100)*ow2_ult_cost_REAPER
    ult_cost[heroID(Hero.SOLDIER)] = 1/(roundedPercent(ow2_ult_cost_SOLDIER/ow1_ult_cost_SOLDIER)/100)*ow2_ult_cost_SOLDIER
    ult_cost[heroID(Hero.SOMBRA)] = 1/(roundedPercent(ow2_ult_cost_SOMBRA/ow1_ult_cost_SOMBRA)/100)*ow2_ult_cost_SOMBRA
    ult_cost[heroID(Hero.SYMMETRA)] = 1/(roundedPercent(ow2_ult_cost_SYMMETRA/ow1_ult_cost_SYMMETRA)/100)*ow2_ult_cost_SYMMETRA
    ult_cost[heroID(Hero.TORBJORN)] = 1/(roundedPercent(ow2_ult_cost_TORBJORN/ow1_ult_cost_TORBJORN)/100)*ow2_ult_cost_TORBJORN
    ult_cost[heroID(Hero.TRACER)] = 1/(roundedPercent(ow2_ult_cost_TRACER/ow1_ult_cost_TRACER)/100)*ow2_ult_cost_TRACER
    ult_cost[heroID(Hero.WIDOWMAKER)] = 1/(roundedPercent(ow2_ult_cost_WIDOWMAKER/ow1_ult_cost_WIDOWMAKER)/100)*ow2_ult_cost_WIDOWMAKER
    ult_cost[heroID(Hero.ANA)] = 1/(roundedPercent(ow2_ult_cost_ANA/ow1_ult_cost_ANA)/100)*ow2_ult_cost_ANA
    ult_cost[heroID(Hero.BAPTISTE)] = 1/(roundedPercent(ow2_ult_cost_BAPTISTE/ow1_ult_cost_BAPTISTE)/100)*ow2_ult_cost_BAPTISTE
    ult_cost[heroID(Hero.BRIGITTE)] = 1/(roundedPercent(ow2_ult_cost_BRIGITTE/ow1_ult_cost_BRIGITTE)/100)*ow2_ult_cost_BRIGITTE
    ult_cost[heroID(Hero.LUCIO)] = 1/(roundedPercent(ow2_ult_cost_LUCIO/ow1_ult_cost_LUCIO)/100)*ow2_ult_cost_LUCIO
    ult_cost[heroID(Hero.MERCY)] = 1/(roundedPercent(ow2_ult_cost_MERCY/ow1_ult_cost_MERCY)/100)*ow2_ult_cost_MERCY
    ult_cost[heroID(Hero.MOIRA)] = 1/(roundedPercent(ow2_ult_cost_MOIRA/ow1_ult_cost_MOIRA)/100)*ow2_ult_cost_MOIRA
    ult_cost[heroID(Hero.ZENYATTA)] = 1/(roundedPercent(ow2_ult_cost_ZENYATTA/ow1_ult_cost_ZENYATTA)/100)*ow2_ult_cost_ZENYATTA

def compensateUltPercent():
    @Name "[ult_charge.opy]: Compensate missing ultimate percentage"
    
    if eventPlayer.missing_ult_points/ult_cost[eventPlayer.hero_id] > 0:
        eventPlayer.ult_percent_compensated = percent(eventPlayer.missing_ult_points/ult_cost[eventPlayer.hero_id]) + 3 # add 3% extra to compensate for rounding error
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventPlayer.ult_percent_compensated)
        eventPlayer.ult_charge_compensated = percentOf(eventPlayer.ult_percent_compensated, ult_cost[eventPlayer.hero_id])
        eventPlayer.missing_ult_points -= eventPlayer.ult_charge_compensated

rule "Remember missing ult charge from damaging tank":
    @Event playerDealtDamage
    @Condition victim != eventPlayer
    @Condition any([victim.getCurrentHero() == tank_hero for tank_hero in getTankHeroes()])
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points += 0.3*eventDamage
    compensateUltPercent()

rule "Remember missing ult charge from healing tank":
    @Event playerDealtHealing
    @Condition any([healee.getCurrentHero() == tank_hero for tank_hero in getTankHeroes()])
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points += 0.3*eventHealing
    compensateUltPercent()

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
