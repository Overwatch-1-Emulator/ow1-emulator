#!include "./utilities.opy"
#!include "./hp.opy"
#!include "./ult_charge.opy"

playervar is_pilot_dva

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


rule "set pilot dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.is_pilot_dva == true
    
    ult_cost[heroID(Hero.DVA)] = 280.9


rule "set meka dva ult cost":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.is_pilot_dva == false
    
    ult_cost[heroID(Hero.DVA)] = 1540
