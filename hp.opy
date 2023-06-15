#!include "./utilities.opy"
#!include "./custom_health_handler.opy"

#Global variables
globalvar hero_health
globalvar hero_health_normal
globalvar hero_health_armor
globalvar hero_health_shields

playervar total_health
playervar last_position

rule "initialize overwatch 1 hero healths":
    hero_health[heroID(Hero.DVA)] = 600
    hero_health[heroID(Hero.REINHARDT)] = 500
    hero_health[heroID(Hero.ROADHOG)] = 600
    hero_health[heroID(Hero.SIGMA)] = 400
    hero_health[heroID(Hero.WINSTON)] = 500
    hero_health[heroID(Hero.HAMMOND)] = 600
    hero_health[heroID(Hero.ZARYA)] = 400

    hero_health_normal[heroID(Hero.REINHARDT)] = 300
    hero_health_armor[heroID(Hero.REINHARDT)] = 200


rule "fix health on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    # fixHealth()
    wait(0.25)
    setCustomHealth(hero_health_normal[eventPlayer.hero_id], hero_health_armor[eventPlayer.hero_id], hero_health_shields[eventPlayer.hero_id])
    # DVa special case:
    # updating her max health updates the pilot health, but not her mech health for some reason
    # her mech has to be respawned for health change to go in effect
    if eventPlayer.getCurrentHero() == Hero.DVA:
        eventPlayer.last_position = eventPlayer.getPosition()
        eventPlayer.respawn()
        eventPlayer.teleport(eventPlayer.last_position)
