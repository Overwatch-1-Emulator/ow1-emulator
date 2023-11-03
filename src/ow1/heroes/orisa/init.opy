#!mainFile "../../../main.opy"

#!include "ow1/heroes/orisa/supercharger.opy"
#!include "ow1/heroes/orisa/halt.opy"
#!include "ow1/heroes/orisa/barrier.opy"
#!include "ow1/heroes/orisa/gun.opy"
#!include "ow1/heroes/orisa/fortify.opy"

rule "[orisa/init.opy]: Initialize Orisa":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init
    
    resetHero()
    setCustomHealth(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)

    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_orisa_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_orisa_player = eventPlayer
    
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.is_using_supercharger = false

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.is_using_halt = false

    eventPlayer.disallowButton(Button.ABILITY_2)

    resetFusionDriver()
    showOrisaAmmoHud()
    eventPlayer.is_orisa_reloading = false
    eventPlayer.setDamageDealt(percent(OW1_ORISA_GUN_DAMAGE/OW2_ORISA_GUN_DAMAGE))

    removeTankPassive()

    eventPlayer.call_init = false


rule "[orisa/init.opy]: Clean up Orisa":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.ORISA

    destroyBarrier()
    endSupercharger()
    hideOrisaAmmoHud()
