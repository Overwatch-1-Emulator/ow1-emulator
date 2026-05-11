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
    eventPlayer.startScalingSize(MODEL_SIZE_PRE_SEASON_9, true)

    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    setBaseHealing(eventPlayer, 296/OW2_ROADHOG_BREATHER_HEAL_TOTAL) # I think this needs to be exact because when I was playing I noticed with the anti healing passive number was off sometimes

    eventPlayer.disallowButton(Button.ABILITY_2)

    eventPlayer.preloadHero(Hero.ZARYA)
    eventPlayer.preloadHero(Hero.ROADHOG)
    eventPlayer._is_exiting_wholehog = false

rule "[roadhog/init.opy]: Deal OW1 Scrap Gun damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    if eventDamage < OW1_ROADHOG_SCRAP_GUN_PRE_DETONATION_DAMAGE:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
