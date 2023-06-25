rule "Turret mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setMoveSpeed(0) # Bastion cannot move during turret form
    waitUntil(not eventPlayer.isUsingAbility1(), 10)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setMoveSpeed(100) # Reenable movement
