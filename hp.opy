#!include "./utilities.opy"

#Global variables
globalvar ow1_hero_health
globalvar ow2_hero_health

#Player variables
playervar percent_hp_scalar


rule "detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.last_hero_played != eventPlayer.getCurrentHero()
    
    eventPlayer.hero_switched = true
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    wait()
    eventPlayer.hero_switched = false


rule "initialize overwatch 1 hero healths":
    ow1_hero_health[heroID(Hero.DVA)] = 600
    ow1_hero_health[heroID(Hero.REINHARDT)] = 500
    ow1_hero_health[heroID(Hero.ROADHOG)] = 600
    ow1_hero_health[heroID(Hero.SIGMA)] = 400
    ow1_hero_health[heroID(Hero.WINSTON)] = 500
    ow1_hero_health[heroID(Hero.HAMMOND)] = 600
    ow1_hero_health[heroID(Hero.ZARYA)] = 400


rule "modify hero health to overwatch 1":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true
    
    eventPlayer.setMaxHealth(100)
    wait()
    ow2_hero_health[heroID(eventPlayer.getCurrentHero())] = eventPlayer.getMaxHealth()
    if ow1_hero_health[heroID(eventPlayer.getCurrentHero())] != 0:
        eventPlayer.percent_hp_scalar = 100 * ow1_hero_health[heroID(eventPlayer.getCurrentHero())] / ow2_hero_health[heroID(eventPlayer.getCurrentHero())]
        eventPlayer.setMaxHealth(eventPlayer.percent_hp_scalar)
