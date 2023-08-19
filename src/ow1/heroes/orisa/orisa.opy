#!mainFile "../../../main.opy"

#!include "ow1/heroes/orisa/hp.opy"
#!include "ow1/heroes/orisa/supercharger.opy"
#!include "ow1/heroes/orisa/halt.opy"
#!include "ow1/heroes/orisa/barrier.opy"
#!include "ow1/heroes/orisa/ammo.opy"
#!include "ow1/heroes/orisa/fortify.opy"

rule "[orisa/orisa.opy]: Initialize Orisa":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_initialize == true
    
    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_orisa_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_orisa_player = eventPlayer
