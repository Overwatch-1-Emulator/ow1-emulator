#!mainFile "../../dev_main.opy"

rule "[orisa/barrier.opy]: OW1 Orisa barrier health":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0

    eventPlayer.setMaxHealth(percent(OW1_ORISA_PROJECTILE_BARRIER_HEALTH/OW2_ORISA_PROJECTILE_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2(), 1)
    wait(OW2_ORISA_PROJECTILE_BARRIER_DURATION, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
