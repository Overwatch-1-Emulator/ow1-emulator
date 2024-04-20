#!mainFile "../../main.opy"


rule "[baptiste/regen_burst.opy]: Remove initial burst healing from regenerative burst":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setHealingDealt(0)
    waitUntil(eventPlayer.isUsingAbility1() == false, Math.INFINITY)
    eventPlayer.setHealingDealt(100)


rule "[baptiste/regen_burst.opy]: Allow self healing during regenerative burst":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility1()

    pushSelfHealing(Button.ABILITY_1)
    wait(OW1_BAPTISTE_REGEN_BURST_DURATION, Wait.RESTART_WHEN_TRUE)
    popSelfHealing(Button.ABILITY_1)


rule "[baptiste/regen_burst.opy]: OW1 regenerative burst self hps":
    @Event playerDealtHealing
    @Hero baptiste
    @Condition healee == healer
    @Condition eventAbility == Button.ABILITY_1
    
    heal(healee, healer, eventHealing*(OW1_BAPTISTE_REGEN_BURST_SELF_HPS/OW2_BAPTISTE_REGEN_BURST_SELF_HPS)-eventHealing)


rule "[baptiste/regen_burst.opy]: OW1 regenerative burst ally hps":
    @Event playerDealtHealing
    @Hero baptiste
    @Condition eventAbility == Button.ABILITY_1
    @Condition healee != healer
    
    heal(healee, healer, eventHealing*(OW1_BAPTISTE_REGEN_BURST_ALLY_HPS/OW2_BAPTISTE_REGEN_BURST_ALLY_HPS)-eventHealing)
