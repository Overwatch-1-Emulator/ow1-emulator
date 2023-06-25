#!include "ow1_constants.opy"

rule "Force single firestrike":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility2() == true

    waitUntil(not eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 0)
    wait(ow1_cooldown_ability2_REINHARDT)
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
