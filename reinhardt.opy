rule "Force single firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0)
