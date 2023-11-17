#!mainFile "../../../main.opy"

#!include "ow1/heroes/roadhog/hook.opy"
#!include "ow1/heroes/roadhog/breather.opy"
#!include "ow1/heroes/roadhog/wholehog.opy"


rule "[roadhog/init.opy]: Initialize Roadhog":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.call_init

    resetHero()
    setCustomHealth(OW1_ROADHOG_HEALTH, 0, 0)

    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE)

    # eventPlayer.setDamageDealt(percent(OW1_ROADHOG_SCRAP_GUN_DAMAGE/OW2_ROADHOG_SCRAP_GUN_DAMAGE))

    # Breather init
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    removeTankPassive()
    eventPlayer.call_init = false
