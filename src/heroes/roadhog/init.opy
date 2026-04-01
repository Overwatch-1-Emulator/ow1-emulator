#!mainFile "../../main.opy"

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

    eventPlayer.setDamageDealt(percent(OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE))
    eventPlayer.setHealingDealt(percent(OW1_ROADHOG_BREATHER_HEAL_TOTAL/OW2_ROADHOG_BREATHER_HEAL_TOTAL)-1.6)
    #-1.6 is set there because idk why but its 300 healing when its like that

    eventPlayer.preloadHero(Hero.ZARYA)
    eventPlayer.preloadHero(Hero.ROADHOG)
    eventPlayer._is_exiting_wholehog = false

rule "[roadhog/init.opy]: Deal OW1 Scrap Gun damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)


