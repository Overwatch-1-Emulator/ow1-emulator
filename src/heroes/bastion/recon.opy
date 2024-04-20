#!mainFile "../../main.opy"


rule "[bastion/recon.opy]: Initialize recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isInAlternateForm() # built in workshop function for detecting default hero form

    eventPlayer.current_configuration = Configuration.RECON

    eventPlayer.setMoveSpeed(100)
    setBaseDamage(eventPlayer, 1)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setKnockbackReceived(100)


# rule "[bastion/sentry.opy]: OW1 Bastion recon fire rate":
#     @Event eachPlayer
#     @Hero bastion
#     @Condition eventPlayer.isFiringPrimaryFire()

#     do:
#         eventPlayer.setProjectileSpeed(100)
#         wait(1/OW1_BASTION_RECON_GUN_FIRERATE)
#     while (RULE_CONDITION)
