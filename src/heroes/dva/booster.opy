#!mainFile "../../dev_main.opy"


rule "[dva/booster.opy]: Decouple melee button from activating melee animation during booster":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.DVA
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.disallowButton(Button.MELEE)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.allowButton(Button.MELEE)


rule "[dva/booster.opy]: Cancel booster if melee pressed":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.DVA
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.forceButtonPress(Button.MELEE)
    eventPlayer.disallowButton(Button.MELEE)


rule "[dva/booster.opy]: Reduce boosters damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.DVA
    @Condition eventAbility == Button.ABILITY_1

    heal(victim, null, OW2_DVA_BOOSTERS_DAMAGE - OW1_DVA_BOOSTERS_DAMAGE)
