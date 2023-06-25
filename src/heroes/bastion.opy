rule "Turret mode":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setMoveSpeed(0) # Bastion cannot move during turret form
    waitUntil(not eventPlayer.isUsingAbility1(), 10)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setMoveSpeed(100) # Reenable movement

rule "Heal using ability 2/secondary fire":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    wait(0.5) # 0.5 second cast time
    while eventPlayer.isHoldingButton(Button.ABILITY_2) or eventPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        # Heal 1.44 hp every game tick (1 tick/0.016 seconds) to approximate 90 healing per second
        wait()
        heal(eventPlayer, eventPlayer, 1.44)