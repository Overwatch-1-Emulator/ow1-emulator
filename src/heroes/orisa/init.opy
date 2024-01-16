#!mainFile "../../main.opy"

#!include "heroes/orisa/supercharger.opy"
#!include "heroes/orisa/halt.opy"
#!include "heroes/orisa/barrier.opy"
#!include "heroes/orisa/fusion_driver.opy"
#!include "heroes/orisa/fortify.opy"

rule "[orisa/init.opy]: Detect switch to Orisa":
    @Event eachPlayer
    @Hero orisa

    eventPlayer.call_init = true


rule "[orisa/init.opy]: Initialize Orisa":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init
    
    newHero(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
    setUltCost(OW1_ORISA_ULT_COST)

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
    setBaseDamage(eventPlayer, OW1_ORISA_GUN_DAMAGE/OW2_ORISA_GUN_DAMAGE)
    eventPlayer.setProjectileSpeed(percent(OW1_ORISA_GUN_PROJECTILE_SPEED/OW2_ORISA_GUN_PROJECTILE_SPEED))

    removeTankPassive()

    eventPlayer.call_init = false


rule "[orisa/init.opy]: Clean up Orisa":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() != Hero.ORISA

    destroyBarrier()
    endSupercharger()
    hideOrisaAmmoHud()
