#!mainFile "../../main.opy"


rule "[dva/booster.opy]: Decouple melee button from activating melee animation during booster":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.disallowButton(Button.MELEE)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.allowButton(Button.MELEE)


rule "[dva/booster.opy]: Cancel booster if melee pressed":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.disallowButton(Button.MELEE)


rule "[dva/booster.opy]: Increase booster Damage":
    @Event playerDealtDamage
    @Hero dva
    @Condition eventAbility == Button.ABILITY_1

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_DVA_BOOSTERS_DAMAGE_VS_ARMOR/OW2_DVA_BOOSTERS_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_DVA_BOOSTERS_DAMAGE/OW2_DVA_BOOSTERS_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)