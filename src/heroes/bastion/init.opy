#!mainFile "../../dev_main.opy"

#!include "configuration.opy"
#!include "repair.opy"
#!include "machine_gun.opy"


def initBastion():
    @Name "[bastion/init.opy]: initBastion()"
    
    setCustomHp(OW1_BASTION_HEALTH, OW1_BASTION_ARMOR, 0)
    setUltCost(OW1_BASTION_ULT_COST)
    eventPlayer.machine_gun_ammo = OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE
    eventPlayer.machine_gun_reload_timer = 0

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.self_repair_time_left = OW1_BASTION_MAX_SELF_REPAIR_DURATION

    #removeSelfHealing()





rule "[bastion/init.opy]: Clean up Bastion":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BASTION
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.BASTION, Math.INFINITY)
    hideMachineGunAmmo()
    hideSelfRepairResource()
    hideSelfRepairRing()
