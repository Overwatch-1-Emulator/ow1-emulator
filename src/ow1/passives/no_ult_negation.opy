#!mainFile "../../main.opy"

# Global variables
globalvar ult_cost

# Player variables
playervar healing_dealt
playervar damage_dealt
playervar missing_ult_points
playervar ult_percent_compensated
playervar ult_charge_compensated

rule "[ult_charge.opy]: initialize overwatch 1 ultimate costs":
    ult_cost[heroID(Hero.DVA)] = 1/(roundedPercent(OW2_DVA_ULT_COST/OW1_DVA_ULT_COST)/100)*OW2_DVA_ULT_COST
    ult_cost[heroID(Hero.REINHARDT)] = 1/(roundedPercent(OW2_REINHARDT_ULT_COST/OW1_REINHARDT_ULT_COST)/100)*OW2_REINHARDT_ULT_COST
    ult_cost[heroID(Hero.ROADHOG)] = 1/(roundedPercent(OW2_ROADHOG_ULT_COST/OW1_ROADHOG_ULT_COST)/100)*OW2_ROADHOG_ULT_COST
    ult_cost[heroID(Hero.SIGMA)] = 1/(roundedPercent(OW2_SIGMA_ULT_COST/OW1_SIGMA_ULT_COST)/100)*OW2_SIGMA_ULT_COST
    ult_cost[heroID(Hero.WINSTON)] = 1/(roundedPercent(OW2_WINSTON_ULT_COST/OW1_WINSTON_ULT_COST)/100)*OW2_WINSTON_ULT_COST
    ult_cost[heroID(Hero.HAMMOND)] = 1/(roundedPercent(OW2_WRECKING_BALL_ULT_COST/OW1_WRECKING_BALL_ULT_COST)/100)*OW2_WRECKING_BALL_ULT_COST
    ult_cost[heroID(Hero.ZARYA)] = 1/(roundedPercent(OW2_ZARYA_ULT_COST/OW1_ZARYA_ULT_COST)/100)*OW2_ZARYA_ULT_COST
    ult_cost[heroID(Hero.ASHE)] = 1/(roundedPercent(OW2_ASHE_ULT_COST/OW1_ASHE_ULT_COST)/100)*OW2_ASHE_ULT_COST
    ult_cost[heroID(Hero.BASTION)] = 1/(roundedPercent(OW2_BASTION_ULT_COST/OW1_BASTION_ULT_COST)/100)*OW2_BASTION_ULT_COST
    ult_cost[heroID(Hero.MCCREE)] = 1/(roundedPercent(OW2_MCCREE_ULT_COST/OW1_MCCREE_ULT_COST)/100)*OW2_MCCREE_ULT_COST
    ult_cost[heroID(Hero.ECHO)] = 1/(roundedPercent(OW2_ECHO_ULT_COST/OW1_ECHO_ULT_COST)/100)*OW2_ECHO_ULT_COST
    ult_cost[heroID(Hero.GENJI)] = 1/(roundedPercent(OW2_GENJI_ULT_COST/OW1_GENJI_ULT_COST)/100)*OW2_GENJI_ULT_COST
    ult_cost[heroID(Hero.HANZO)] = 1/(roundedPercent(OW2_HANZO_ULT_COST/OW1_HANZO_ULT_COST)/100)*OW2_HANZO_ULT_COST
    ult_cost[heroID(Hero.JUNKRAT)] = 1/(roundedPercent(OW2_JUNKRAT_ULT_COST/OW1_JUNKRAT_ULT_COST)/100)*OW2_JUNKRAT_ULT_COST
    ult_cost[heroID(Hero.MEI)] = 1/(roundedPercent(OW2_MEI_ULT_COST/OW1_MEI_ULT_COST)/100)*OW2_MEI_ULT_COST
    ult_cost[heroID(Hero.PHARAH)] = 1/(roundedPercent(OW2_PHARAH_ULT_COST/OW1_PHARAH_ULT_COST)/100)*OW2_PHARAH_ULT_COST
    ult_cost[heroID(Hero.REAPER)] = 1/(roundedPercent(OW2_REAPER_ULT_COST/OW1_REAPER_ULT_COST)/100)*OW2_REAPER_ULT_COST
    ult_cost[heroID(Hero.SOLDIER)] = 1/(roundedPercent(OW2_SOLDIER_ULT_COST/OW1_SOLDIER_ULT_COST)/100)*OW2_SOLDIER_ULT_COST
    ult_cost[heroID(Hero.SOMBRA)] = 1/(roundedPercent(OW2_SOMBRA_ULT_COST/OW1_SOMBRA_ULT_COST)/100)*OW2_SOMBRA_ULT_COST
    ult_cost[heroID(Hero.SYMMETRA)] = 1/(roundedPercent(OW2_SYMMETRA_ULT_COST/OW1_SYMMETRA_ULT_COST)/100)*OW2_SYMMETRA_ULT_COST
    ult_cost[heroID(Hero.TORBJORN)] = 1/(roundedPercent(OW2_TORBJORN_ULT_COST/OW1_TORBJORN_ULT_COST)/100)*OW2_TORBJORN_ULT_COST
    ult_cost[heroID(Hero.TRACER)] = 1/(roundedPercent(OW2_TRACER_ULT_COST/OW1_TRACER_ULT_COST)/100)*OW2_TRACER_ULT_COST
    ult_cost[heroID(Hero.WIDOWMAKER)] = 1/(roundedPercent(OW2_WIDOWMAKER_ULT_COST/OW1_WIDOWMAKER_ULT_COST)/100)*OW2_WIDOWMAKER_ULT_COST
    ult_cost[heroID(Hero.ANA)] = 1/(roundedPercent(OW2_ANA_ULT_COST/OW1_ANA_ULT_COST)/100)*OW2_ANA_ULT_COST
    ult_cost[heroID(Hero.BAPTISTE)] = 1/(roundedPercent(OW2_BAPTISTE_ULT_COST/OW1_BAPTISTE_ULT_COST)/100)*OW2_BAPTISTE_ULT_COST
    ult_cost[heroID(Hero.BRIGITTE)] = 1/(roundedPercent(OW2_BRIGITTE_ULT_COST/OW1_BRIGITTE_ULT_COST)/100)*OW2_BRIGITTE_ULT_COST
    ult_cost[heroID(Hero.LUCIO)] = 1/(roundedPercent(OW2_LUCIO_ULT_COST/OW1_LUCIO_ULT_COST)/100)*OW2_LUCIO_ULT_COST
    ult_cost[heroID(Hero.MERCY)] = 1/(roundedPercent(OW2_MERCY_ULT_COST/OW1_MERCY_ULT_COST)/100)*OW2_MERCY_ULT_COST
    ult_cost[heroID(Hero.MOIRA)] = 1/(roundedPercent(OW2_MOIRA_ULT_COST/OW1_MOIRA_ULT_COST)/100)*OW2_MOIRA_ULT_COST
    ult_cost[heroID(Hero.ZENYATTA)] = 1/(roundedPercent(OW2_ZENYATTA_ULT_COST/OW1_ZENYATTA_ULT_COST)/100)*OW2_ZENYATTA_ULT_COST


rule "[ult_charge.opy]: Update the damage and healing dealt for every player":
    @Event eachPlayer
    # Get the damage and healing dealt by every player to update the h
    while true :
        
        if not eventPlayer.isUsingUltimate():
            eventPlayer.missing_ult_points += eventPlayer.getStatistic(Stat.HEALING_DEALT) - eventPlayer.healing_dealt 
            eventPlayer.missing_ult_points += eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT) - eventPlayer.damage_dealt 
        eventPlayer.healing_dealt = eventPlayer.getStatistic(Stat.HEALING_DEALT)
        eventPlayer.damage_dealt = eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)
        wait(OW1_REFRESH_ULTIMATE_TIME)

rule "[ult_charge.opy]: Reimplement passive ult charge":
    @Event eachPlayer
    @Condition isGameInProgress() == true
    
    while isGameInProgress() == true :
        if not eventPlayer.isUsingUltimate():
            eventPlayer.missing_ult_points += ULT_CHARGE_PER_SECOND
        wait(1)

rule "[ult_charge.opy]: Implement ult charge":
    @Event eachPlayer
    @Condition eventPlayer.missing_ult_points >= ult_cost[eventPlayer.hero_id] * 0.01
    @Condition eventPlayer.isUsingUltimate() == false

    eventPlayer.ult_percent_compensated = percent(eventPlayer.missing_ult_points /ult_cost[eventPlayer.hero_id]) 
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + eventPlayer.ult_percent_compensated - (eventPlayer.ult_percent_compensated %1))
    eventPlayer.ult_charge_compensated = percentOf((eventPlayer.ult_percent_compensated - (eventPlayer.ult_percent_compensated %1) ), ult_cost[eventPlayer.hero_id])
    eventPlayer.missing_ult_points -= eventPlayer.ult_charge_compensated


rule "[ult_charge.opy]: Reset ult compensation after using ult":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.missing_ult_points = 0
    eventPlayer.ult_percent_compensated = 0
