#!mainFile "../../dev_main.opy"


rule "[soldier/biotic_field.opy]: Allow self healing during Biotic Field":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventPlayer.isUsingAbility2()

    pushSelfHealing(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), OW1_SOLDIER_BIOTIC_FIELD_DURATION)
    popSelfHealing(Button.ABILITY_2)
