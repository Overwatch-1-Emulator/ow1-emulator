#!mainFile "../../../main.opy"

#!include "ow1/heroes/sombra/stealth.opy"


rule "[sombra/init.opy]: Initialize Sombra":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.call_init

    resetHero()
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)

    eventPlayer.is_using_stealth = false
    eventPlayer.call_init = false
