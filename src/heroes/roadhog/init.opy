#!mainFile "../../dev_main.opy"

#!include "hook.opy"
#!include "breather.opy"
#!include "wholehog.opy"
# !include "scrap_gun.opy"


def initRoadhog():
    @Name "[roadhog/init.opy]: initRoadhog()"

    setCustomHp(OW1_ROADHOG_HEALTH, 0, 0)
    setUltCost(OW1_ROADHOG_ULT_COST)

    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE)

    #eventPlayer.setDamageDealt(percent(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE))

    # Breather init
    # eventPlayer.disallowButton(Button.ABILITY_2)
    # eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    # eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setHealingDealt(percent(OW1_ROADHOG_BREATHER_HEAL_TOTAL/OW2_ROADHOG_BREATHER_HEAL_TOTAL))

    # removeTankPassive()
    #removeSelfHealing()

    eventPlayer.preloadHero(Hero.ZARYA)
    eventPlayer.preloadHero(Hero.ROADHOG)
    eventPlayer._is_exiting_wholehog = false


# rule "[roadhog/init.opy]: Initialize Roadhog":
#     @Event eachPlayer
#     @Hero roadhog
#     @Condition not eventPlayer._is_exiting_wholehog # guards against initialization when exiting wholehog

#     resetHero()
#     async(initRoadhog, AsyncBehavior.RESTART)

rule "[roadhog/init.opy]: Deal OW1 hog damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    damage(victim, attacker, eventDamage*(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE)-eventDamage)
