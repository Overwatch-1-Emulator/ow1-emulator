#!mainFile "../../main.opy"

#!define OW1_WRECKING_BALL_GRAPPLE_COOLDOWN 5

rule "[wreckingball/grapple.opy]: OW1 Grappling Claw Cooldown":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_WRECKING_BALL_GRAPPLE_COOLDOWN)


rule "[wreckingball/grapple.opy]: Correct Fireball impact damage":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility == Button.SECONDARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(
            victim,
            attacker,
            ((OW1_WRECKING_BALL_FIREBALL_DAMAGE_VS_ARMOR/OW2_WRECKING_BALL_FIREBALL_DAMAGE) \
            * (eventDamage/eventPlayer._base_damage_scalar) \
            - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(
            victim,
            attacker,
            ((OW1_WRECKING_BALL_FIREBALL_DAMAGE/OW2_WRECKING_BALL_FIREBALL_DAMAGE) \
            * (eventDamage/eventPlayer._base_damage_scalar) \
            - eventDamage)/eventPlayer._base_damage_scalar)
