#!mainFile "../../ow1pp_main.opy"

#!include "heroes/bastion/configuration.opy"
#!include "heroes/bastion/repair.opy"
#!include "heroes/bastion/machine_gun.opy"

rule "[bastion/init.opy]: Detect switch to Bastion":
    @Event eachPlayer
    @Hero bastion

    eventPlayer.call_init = true


rule "[bastion/init.opy]: Initialize Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.call_init == true
    
    newHero(OW1_BASTION_HEALTH, OW1_BASTION_ARMOR, 0)
    setUltCost(OW1_BASTION_ULT_COST)
    eventPlayer.machine_gun_ammo = OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE
    eventPlayer.machine_gun_reload_timer = 0

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.self_repair_time_left = OW1_BASTION_MAX_SELF_REPAIR_DURATION
    eventPlayer.is_pressing_self_repair_key = false
    eventPlayer.is_using_self_repair = false

    removePassiveHealing()

    eventPlayer.call_init = false


rule "[bastion/init.opy]: Clean up Bastion":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BASTION
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.BASTION, Math.INFINITY)
    hideMachineGunAmmo()
    hideSelfRepairResource()
    hideSelfRepairRing()
