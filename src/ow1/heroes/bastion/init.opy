#!mainFile "../../../main.opy"

#!include "ow1/heroes/bastion/configuration.opy"
#!include "ow1/heroes/bastion/repair.opy"
#!include "ow1/heroes/bastion/machine_gun.opy"

rule "[bastion/init.opy]: Initialize Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.call_init == true
    
    resetHero()
    eventPlayer.machine_gun_ammo = OW1_BASTION_SENTRY_CONFIG_CLIP_SIZE
    eventPlayer.machine_gun_reload_timer = 0

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.self_repair_time_left = OW1_BASTION_MAX_SELF_REPAIR_DURATION
    eventPlayer.is_pressing_self_repair_key = false
    eventPlayer.is_using_self_repair = false

    eventPlayer.call_init = false


rule "[bastion/init.opy]: Clean up Bastion":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BASTION

    waitUntil(updateEveryTick(eventPlayer.getCurrentHero() != Hero.BASTION), Math.INFINITY)
    
    hideMachineGunAmmoBar()
    hideSelfRepairGui()
