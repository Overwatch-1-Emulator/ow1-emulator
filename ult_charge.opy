#!include "./utilities.opy"

#Global variables
globalvar ow1_ult_cost

#Player variables
playervar ult_points
playervar allow_ult_charge

rule "initialize overwatch 1 ultimate costs":
    ow1_ult_cost[heroID(Hero.DVA)] = 1540
    ow1_ult_cost[heroID(Hero.REINHARDT)] = 1540
    ow1_ult_cost[heroID(Hero.ROADHOG)] = 2240
    ow1_ult_cost[heroID(Hero.SIGMA)] = 1960
    ow1_ult_cost[heroID(Hero.WINSTON)] = 1540
    ow1_ult_cost[heroID(Hero.HAMMOND)] = 1540
    ow1_ult_cost[heroID(Hero.ZARYA)] = 2100
    ow1_ult_cost[heroID(Hero.ASHE)] = 2240
    ow1_ult_cost[heroID(Hero.BASTION)] = 2310
    ow1_ult_cost[heroID(Hero.MCCREE)] = 1680
    ow1_ult_cost[heroID(Hero.ECHO)] = 2254
    ow1_ult_cost[heroID(Hero.GENJI)] = 1932
    ow1_ult_cost[heroID(Hero.HANZO)] = 1680
    ow1_ult_cost[heroID(Hero.JUNKRAT)] = 1925
    ow1_ult_cost[heroID(Hero.MEI)] = 1610
    ow1_ult_cost[heroID(Hero.PHARAH)] = 2100
    ow1_ult_cost[heroID(Hero.REAPER)] = 2100
    ow1_ult_cost[heroID(Hero.SOLDIER)] = 2310
    ow1_ult_cost[heroID(Hero.SOMBRA)] = 1400
    ow1_ult_cost[heroID(Hero.SYMMETRA)] = 1680
    ow1_ult_cost[heroID(Hero.TORBJORN)] = 2142
    ow1_ult_cost[heroID(Hero.TRACER)] = 1260
    ow1_ult_cost[heroID(Hero.WIDOWMAKER)] = 1540
    ow1_ult_cost[heroID(Hero.ANA)] = 2100
    ow1_ult_cost[heroID(Hero.BAPTISTE)] = 2310
    ow1_ult_cost[heroID(Hero.BRIGITTE)] = 2800
    ow1_ult_cost[heroID(Hero.LUCIO)] = 2940
    ow1_ult_cost[heroID(Hero.MERCY)] = 1820
    ow1_ult_cost[heroID(Hero.MOIRA)] = 2800
    ow1_ult_cost[heroID(Hero.ZENYATTA)] = 2310


rule "allow ult charge by default":
    @Event eachPlayer
    
    eventPlayer.allow_ult_charge = true


rule "disable ult charge when entering ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.allow_ult_charge = false


rule "allow ult charge when exiting ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(2)
    eventPlayer.allow_ult_charge = true


rule "disable ult charge before game begins":
    @Event eachPlayer
    @Condition isGameInProgress() == false
    @Condition isWaitingForPlayers() == false
    
    eventPlayer.allow_ult_charge = false


rule "enable ult charge after game begins":
    @Event eachPlayer
    @Condition (isGameInProgress() or isWaitingForPlayers()) == true
    
    eventPlayer.allow_ult_charge = true


rule "damage ult charge":
    @Event playerDealtDamage
    @Condition victim != eventPlayer
    @Condition eventPlayer.allow_ult_charge == true
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.ult_points += eventDamage
    eventPlayer.setUltCharge(100 * (eventPlayer.ult_points / ow1_ult_cost[heroID(eventPlayer.getCurrentHero())]))


rule "healing ult charge":
    @Event playerDealtHealing
    @Condition eventPlayer.allow_ult_charge == true
    @Condition eventPlayer.getUltCharge() < 100
    
    eventPlayer.ult_points += eventHealing
    eventPlayer.setUltCharge(100 * (eventPlayer.ult_points / ow1_ult_cost[heroID(eventPlayer.getCurrentHero())]))


rule "passive ult charge":
    @Event eachPlayer
    @Condition eventPlayer.allow_ult_charge == true
    @Condition eventPlayer.getUltCharge() < 100
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.ult_points += 5
    eventPlayer.setUltCharge(100 * (eventPlayer.ult_points / ow1_ult_cost[heroID(eventPlayer.getCurrentHero())]))
    if RULE_CONDITION:
        goto RULE_START


rule "reset ult charge after using ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setUltCharge(0)
    eventPlayer.ult_points = 0


rule "reset ult after switching hero":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true
    
    eventPlayer.setUltCharge(0)
    eventPlayer.ult_points = 0
