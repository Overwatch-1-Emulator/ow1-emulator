#!mainFile "../../dev_main.opy"

#!include "emp.opy"
#!include "hack.opy"
#!include "stealth.opy"
#!include "translocator.opy"


def initSombra():
    @Name "[sombra/init.opy]: initSombra()"

    setCustomHp(OW1_SOMBRA_HEALTH, 0, 0)
    setUltCost(OW1_SOMBRA_ULT_COST)

    getPlayers(eventPlayer.getTeam()).friendly_sombra_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_sombra_player = eventPlayer
    
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)

    eventPlayer.is_using_stealth = false
    # removeSelfHealing()


rule "[sombra/init.opy]: Clean up Sombra":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.SOMBRA

    waitUntil(eventPlayer.getCurrentHero() != Hero.SOMBRA, Math.INFINITY)
    exitStealth()
    destroyTranslocator(eventPlayer)
