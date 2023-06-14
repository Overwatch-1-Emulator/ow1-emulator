#!include "./utilities.opy"
#!include "./constants.opy"

# Global variables
globalvar ow1_ult_cost
globalvar ow2_ult_cost

# Player variables
playervar ult_points
playervar ult_points_backup
playervar allow_ult_charge

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


rule "pilot dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getMaxHealth() < 300
    @Condition eventPlayer.isUsingUltimate() == false
    
    ow1_ult_cost[heroID(Hero.DVA)] = 280.9
    eventPlayer.ult_points_backup = eventPlayer.ult_points
    eventPlayer.ult_points = 0


rule "regular dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getMaxHealth() >= 300
    
    ow1_ult_cost[heroID(Hero.DVA)] = 1540
    eventPlayer.ult_points = eventPlayer.ult_points_backup
    eventPlayer.ult_points_backup = 0


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
    eventPlayer.ult_points_backup = 0


