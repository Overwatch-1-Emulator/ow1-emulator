#!mainFile "../../../main.opy"

#!include "heroes/sombra/hack.opy"
#!include "heroes/sombra/stealth.opy"
#!include "heroes/sombra/translocator.opy"
#!include "heroes/sombra/emp.opy"


rule "[sombra/init.opy]: Initialize Sombra":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.call_init

    defaultHero()

    getPlayers(eventPlayer.getTeam()).friendly_sombra_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_sombra_player = eventPlayer
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)

    eventPlayer.is_using_stealth = false
    eventPlayer.call_init = false


rule "[sombra/init.opy]: Clean up Sombra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.SOMBRA

    exitStealth()
    destroyTranslocator()
