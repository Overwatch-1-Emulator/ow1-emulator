#!mainFile "../../dev_main.opy"

#!include "heroes/roadhog/hook.opy"
#!include "heroes/roadhog/breather.opy"
#!include "heroes/roadhog/wholehog.opy"
#!include "heroes/roadhog/scrap_gun.opy"


def initRoadhog():
    @Name "[roadhog/init.opy]: initRoadhog()"

    setCustomHp(OW1_ROADHOG_HEALTH, 0, 0)
    setUltCost(OW1_ROADHOG_ULT_COST)

    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE)

    # eventPlayer.setDamageDealt(percent(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE))

    # Breather init
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.setHealingDealt(percent(OW1_ROADHOG_BREATHER_HEAL_TOTAL/OW2_ROADHOG_BREATHER_HEAL_TOTAL))

    removeTankPassive()
    removeSelfHealing()

    eventPlayer.preloadHero(Hero.ZARYA)
    eventPlayer.preloadHero(Hero.ROADHOG)
    eventPlayer._is_exiting_wholehog = false


rule "[roadhog/init.opy]: Initialize Roadhog":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer._call_init
    @Condition not eventPlayer._is_exiting_wholehog # guards against initialization when exiting wholehog

    initRoadhog()
    eventPlayer._call_init = false
