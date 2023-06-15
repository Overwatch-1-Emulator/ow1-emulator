#!include "./utilities.opy"
#!include "./custom_health_handler.opy"

#Global variables
globalvar ow1_hero_health
globalvar ow2_hero_health

#Player variables
playervar hp_scalar
playervar last_position

rule "initialize overwatch 1 hero healths":
    ow1_hero_health[heroID(Hero.DVA)] = 600
    ow1_hero_health[heroID(Hero.REINHARDT)] = 500
    ow1_hero_health[heroID(Hero.ROADHOG)] = 600
    ow1_hero_health[heroID(Hero.SIGMA)] = 400
    ow1_hero_health[heroID(Hero.WINSTON)] = 500
    ow1_hero_health[heroID(Hero.HAMMOND)] = 600
    ow1_hero_health[heroID(Hero.ZARYA)] = 400

    
def fixHealth():
    # Cache default values for lookup
    if ow2_hero_health[heroID(eventPlayer.getCurrentHero())] == 0:
        # Reset health to default
        eventPlayer.setMaxHealth(100)
        wait() # Wait for health change to go in effect before reading max health value
        ow2_hero_health[heroID(eventPlayer.getCurrentHero())] = eventPlayer.getMaxHealth()

    if ow1_hero_health[heroID(eventPlayer.getCurrentHero())] == 0:
        ow1_hero_health[heroID(eventPlayer.getCurrentHero())] = ow2_hero_health[heroID(eventPlayer.getCurrentHero())]
    
    # Calculate scalar to increase/decrease health
    eventPlayer.hp_scalar = ow1_hero_health[heroID(eventPlayer.getCurrentHero())] / ow2_hero_health[heroID(eventPlayer.getCurrentHero())]
    # then apply the scalar
    eventPlayer.setMaxHealth(percent(eventPlayer.hp_scalar))


rule "fix health on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    # fixHealth()
    wait(3)
    setCustomHealth(200, 100, 50)
    # DVa special case:
    # updating her max health updates the pilot health, but not her mech health for some reason
    # her mech has to be respawned for health change to go in effect
    if eventPlayer.getCurrentHero() == Hero.DVA:
        eventPlayer.last_position = eventPlayer.getPosition()
        eventPlayer.respawn()
        eventPlayer.teleport(eventPlayer.last_position)
