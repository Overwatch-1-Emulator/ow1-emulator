#!mainFile "../../dev_main.opy"


rule "[kiriko/kunai.opy]: OW1 Kunai damage":
    @Event playerDealtDamage
    @Hero kiriko
    # @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventAbility == null # Workshop bug: Kunai event Ability = null instead of secondary fire
    @Condition eventDamage >= OW2_KIRIKO_KUNAI_DAMAGE*eventPlayer._base_damage_scalar
    @Condition not eventWasCriticalHit

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_KIRIKO_KUNAI_DAMAGE/OW2_KIRIKO_KUNAI_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)


# rule "[kiriko/kunai.opy]: OW1 Kiriko fire rate":
#     @Event eachPlayer
#     @Hero kiriko
#     @Condition eventPlayer.isFiringSecondaryFire()
#     @Condition not eventPlayer.isUsingUltimate()

#     eventPlayer.disallowButton(Button.SECONDARY_FIRE)
#     wait(OW1_KIRIKO_KUNAI_RECOVERY_TIME)
#     eventPlayer.allowButton(Button.SECONDARY_FIRE)
#     if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
#         eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
