#!include "./utilities.opy"
#!include "./hp.opy"
#!include "./ult_charge.opy"

playervar is_pilot_dva
playervar meka_ult_points

rule "detect pilot dva":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getMaxHealth() <= 0.5*ow1_hero_health[heroID(Hero.DVA)]

    eventPlayer.is_pilot_dva = true

rule "detect meka dva":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.getMaxHealth() > 0.5*ow1_hero_health[heroID(Hero.DVA)]

    eventPlayer.is_pilot_dva = false


rule "pilot dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.is_pilot_dva == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    ow1_ult_cost[heroID(Hero.DVA)] = 280.9
    eventPlayer.meka_ult_points = eventPlayer.ult_points
    eventPlayer.ult_points = 0


rule "regular dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.is_pilot_dva == false
    
    ow1_ult_cost[heroID(Hero.DVA)] = 1540
    eventPlayer.ult_points = eventPlayer.meka_ult_points
