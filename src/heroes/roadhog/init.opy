#!mainFile "../../main.opy"

#!include "heroes/roadhog/hook.opy"
#!include "heroes/roadhog/breather.opy"
#!include "heroes/roadhog/wholehog.opy"


rule "[roadhog/init.opy]: Initialize when player switches to Roadhog in spawn room":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer._hero_switched
    waitUntil(eventPlayer.isInSpawnRoom(), Math.INFINITY) # staggered conditions because _hero_switched signal arrives faster than isInSpawnRoom()

    eventPlayer.call_init = true


rule "[roadhog/init.opy]: Initialize Roadhog":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.call_init

    newHero(OW1_ROADHOG_HEALTH, 0, 0)
    setUltCost(OW1_ROADHOG_ULT_COST)

    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE)

    # eventPlayer.setDamageDealt(percent(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE))

    # Breather init
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setHealingDealt(percent(OW1_ROADHOG_BREATHER_HEAL_TOTAL/OW2_ROADHOG_BREATHER_HEAL_TOTAL))

    removeTankPassive()
    removePassiveHealing()

    eventPlayer.preloadHero(Hero.ZARYA)
    eventPlayer.preloadHero(Hero.ROADHOG)
    eventPlayer._wholehog_temp_zarya = false

    eventPlayer.call_init = false


rule "[roadhog/init.opy]: Clean up Roadhog":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ROADHOG

    waitUntil(eventPlayer.getCurrentHero() != Hero.ROADHOG, Math.INFINITY)
    eventPlayer._wholehog_temp_zarya = false
