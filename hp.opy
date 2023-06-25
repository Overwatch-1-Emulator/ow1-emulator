#!include "./utilities.opy"
#!include "./ow1_constants.opy"
#!include "./custom_health_handler.opy"

#Global variables
globalvar hero_health
globalvar hero_health_normal
globalvar hero_health_armor
globalvar hero_health_shields

playervar total_health
playervar last_position

rule "initialize overwatch 1 hero healths":
    hero_health_normal[heroID(Hero.DVA)] = ow1_health_normal_DVA
    hero_health_normal[heroID(Hero.REINHARDT)] = ow1_health_normal_REINHARDT
    hero_health_normal[heroID(Hero.ROADHOG)] = ow1_health_normal_ROADHOG
    hero_health_normal[heroID(Hero.SIGMA)] = ow1_health_normal_SIGMA
    hero_health_normal[heroID(Hero.WINSTON)] = ow1_health_normal_WINSTON
    hero_health_normal[heroID(Hero.HAMMOND)] = ow1_health_normal_HAMMOND
    hero_health_normal[heroID(Hero.ZARYA)] = ow1_health_normal_ZARYA
    hero_health_normal[heroID(Hero.ASHE)] = ow1_health_normal_ASHE
    hero_health_normal[heroID(Hero.BASTION)] = ow1_health_normal_BASTION
    hero_health_normal[heroID(Hero.MCCREE)] = ow1_health_normal_MCCREE
    hero_health_normal[heroID(Hero.ECHO)] = ow1_health_normal_ECHO
    hero_health_normal[heroID(Hero.GENJI)] = ow1_health_normal_GENJI
    hero_health_normal[heroID(Hero.HANZO)] = ow1_health_normal_HANZO
    hero_health_normal[heroID(Hero.JUNKRAT)] = ow1_health_normal_JUNKRAT
    hero_health_normal[heroID(Hero.MEI)] = ow1_health_normal_MEI
    hero_health_normal[heroID(Hero.PHARAH)] = ow1_health_normal_PHARAH
    hero_health_normal[heroID(Hero.REAPER)] = ow1_health_normal_REAPER
    hero_health_normal[heroID(Hero.SOLDIER)] = ow1_health_normal_SOLDIER
    hero_health_normal[heroID(Hero.SOMBRA)] = ow1_health_normal_SOMBRA
    hero_health_normal[heroID(Hero.SYMMETRA)] = ow1_health_normal_SYMMETRA
    hero_health_normal[heroID(Hero.TORBJORN)] = ow1_health_normal_TORBJORN
    hero_health_normal[heroID(Hero.TRACER)] = ow1_health_normal_TRACER
    hero_health_normal[heroID(Hero.WIDOWMAKER)] = ow1_health_normal_WIDOWMAKER
    hero_health_normal[heroID(Hero.ANA)] = ow1_health_normal_ANA
    hero_health_normal[heroID(Hero.BAPTISTE)] = ow1_health_normal_BAPTISTE
    hero_health_normal[heroID(Hero.BRIGITTE)] = ow1_health_normal_BRIGITTE
    hero_health_normal[heroID(Hero.LUCIO)] = ow1_health_normal_LUCIO
    hero_health_normal[heroID(Hero.MERCY)] = ow1_health_normal_MERCY
    hero_health_normal[heroID(Hero.MOIRA)] = ow1_health_normal_MOIRA
    hero_health_normal[heroID(Hero.ZENYATTA)] = ow1_health_normal_ZENYATTA

    hero_health_armor[heroID(Hero.DVA)] = ow1_health_armor_DVA
    hero_health_armor[heroID(Hero.REINHARDT)] = ow1_health_armor_REINHARDT
    hero_health_armor[heroID(Hero.WINSTON)] = ow1_health_armor_WINSTON
    hero_health_armor[heroID(Hero.HAMMOND)] = ow1_health_armor_HAMMOND
    hero_health_armor[heroID(Hero.BASTION)] = ow1_health_armor_BASTION
    hero_health_armor[heroID(Hero.TORBJORN)] = ow1_health_armor_TORBJORN
    hero_health_armor[heroID(Hero.BRIGITTE)] = ow1_health_armor_BRIGITTE

    hero_health_shields[heroID(Hero.SIGMA)] = ow1_health_shields_SIGMA
    hero_health_shields[heroID(Hero.ZARYA)] = ow1_health_shields_ZARYA
    hero_health_shields[heroID(Hero.SYMMETRA)] = ow1_health_shields_SYMMETRA
    hero_health_shields[heroID(Hero.ZENYATTA)] = ow1_health_shields_ZENYATTA



rule "fix health on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    do:
        wait(0.25)
        if (hero_health_normal[eventPlayer.hero_id] + hero_health_armor[eventPlayer.hero_id] + hero_health_shields[eventPlayer.hero_id] == 0):
            clearCustomHealth()
            break
        setCustomHealth(hero_health_normal[eventPlayer.hero_id], hero_health_armor[eventPlayer.hero_id], hero_health_shields[eventPlayer.hero_id])
    while (eventPlayer.getMaxHealth() != hero_health_normal[eventPlayer.hero_id] + hero_health_armor[eventPlayer.hero_id] + hero_health_shields[eventPlayer.hero_id])

    # # DVa special case:
    # # updating her max health updates the pilot health, but not her mech health for some reason
    # # her mech has to be respawned for health change to go in effect
    # if eventPlayer.getCurrentHero() == Hero.DVA:
    #     eventPlayer.last_position = eventPlayer.getPosition()
    #     eventPlayer.respawn()
    #     eventPlayer.teleport(eventPlayer.last_position)
