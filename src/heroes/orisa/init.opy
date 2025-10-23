#!mainFile "../../dev_main.opy"

#!include "supercharger.opy"
#!include "halt.opy"
#!include "barrier.opy"
#!include "fusion_driver.opy"
#!include "fortify.opy"

def initOrisa():
    @Name "[orisa/init.opy]: initOrisa()"
    
    setCustomHp(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
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
    setBaseDamage(eventPlayer, OW1_ORISA_FUSION_DRIVER_DAMAGE/OW2_ORISA_FUSION_DRIVER_DAMAGE)
    eventPlayer.setProjectileSpeed(percent(OW1_ORISA_GUN_PROJECTILE_SPEED/OW2_ORISA_GUN_PROJECTILE_SPEED))

    # removeTankPassive()
    #removeSelfHealing()

    setPerkCost(OW2_ORISA_PERK_LVL3_COST)


rule "[orisa/init.opy]: Clean up Orisa":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ORISA

    waitUntil(eventPlayer.getCurrentHero() != Hero.ORISA, Math.INFINITY)
    # destroyBarrier()
    endSupercharger()
    hideOrisaAmmoHud()
