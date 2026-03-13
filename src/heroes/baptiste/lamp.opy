#!mainFile "../../dev_main.opy"


rule "[baptiste/lamp.opy]: OW1 Baptiste Immortality drone health":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0

    eventPlayer.setMaxHealth(percent(OW1_BAPTISTE_LAMP_HP/ OW2_BAPTISTE_LAMP_HP))
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_2)
    wait(1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
