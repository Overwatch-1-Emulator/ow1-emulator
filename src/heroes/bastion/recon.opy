#!mainFile "../../main.opy"


rule "[bastion/recon.opy]: Initialize recon mode":
    @Event eachPlayer
    @Hero bastion
    @Condition not eventPlayer.isInAlternateForm() # built in workshop function for detecting default hero form

    eventPlayer.current_configuration = Configuration.RECON

    eventPlayer.setMoveSpeed(100)
    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)

    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)

    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.setKnockbackReceived(100)


rule "[bastion/recon.opy]: Compensate recon mode global damage reduction":
    @Event playerDealtDamage
    @Hero bastion
    @Condition not eventPlayer.isInAlternateForm() # built in workshop function for detecting default hero form
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)