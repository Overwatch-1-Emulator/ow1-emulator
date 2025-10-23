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
    #eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
    wait(OW2_ORISA_PROJECTILE_BARRIER_DURATION, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))




rule "[orisa/barrier]: OW1 Orisa health blah blah":
    @Event eachPlayer
    @Hero orisa
    #@Condition eventPlayer.getMaxHealthOfType(Health.ARMOR) == 300
    #@Condition eventPlayer.getMaxHealthOfType(Health.NORMAL) == 250
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) > 200
    #@Condition eventPlayer.getHealthOfType(Health.ARMOR) > 250

    eventPlayer.setHealingReceived(0)
    eventPlayer.addHealthPool(Health.NORMAL, 200, false, false)
    eventPlayer.addHealthPool(Health.ARMOR, 250, false, false)
    waitUntil(eventPlayer.getHealthOfType(Health.NORMAL) < 200)
    eventPlayer.setHealingReceived(100)
    heal(eventPlayer, null, 50)


  