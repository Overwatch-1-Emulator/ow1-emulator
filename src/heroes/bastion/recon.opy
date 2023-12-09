#!mainFile "../../../main.opy"


rule "[bastion/recon.opy]: Detect recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isInAlternateForm() # built in workshop function for detecting default hero form

    eventPlayer.current_configuration = Configuration.RECON


rule "[bastion/recon.opy]: Initialize recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.current_configuration == Configuration.RECON

    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)