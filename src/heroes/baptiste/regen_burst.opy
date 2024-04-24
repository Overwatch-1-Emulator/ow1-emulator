#!mainFile "../../dev_main.opy"


rule "[baptiste/regen_burst.opy]: Remove initial burst healing from Regenerative Burst and set cooldown for duplicate":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setHealingDealt(0)
    waitUntil(eventPlayer.isUsingAbility1() == false, Math.INFINITY)
    eventPlayer.setHealingDealt(percent(eventPlayer._base_healing_scalar))
    if eventPlayer.getHeroOfDuplication() == Hero.BAPTISTE:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 13)


rule "[baptiste/regen_burst.opy]: Allow self healing during regenerative burst":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventPlayer.isUsingAbility1()

    pushSelfHealing(Button.ABILITY_1)
    wait(OW1_BAPTISTE_REGEN_BURST_DURATION, Wait.RESTART_WHEN_TRUE)
    popSelfHealing(Button.ABILITY_1)


rule "[baptiste/regen_burst.opy]: Correct regenerative burst self hps":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition healee == healer
    @Condition eventAbility == Button.ABILITY_1
    
    heal(
        healee, 
        healer, 
        ((eventHealing/eventPlayer._base_healing_scalar)*(ADJ_BAPTISTE_REGEN_BURST_SELF_HPS/OW2_BAPTISTE_REGEN_BURST_SELF_HPS) - eventHealing))


rule "[baptiste/regen_burst.opy]: Correct regenerative burst ally hps":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.BAPTISTE
    @Condition eventAbility == Button.ABILITY_1
    @Condition healee != healer
    
    heal(
        healee, 
        healer, 
        ((eventHealing/eventPlayer._base_healing_scalar)*(ADJ_BAPTISTE_REGEN_BURST_ALLY_HPS/OW2_BAPTISTE_REGEN_BURST_ALLY_HPS) - eventHealing))
