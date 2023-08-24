#!mainFile "../../main.opy"


rule "[baptiste.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)


rule "[baptiste.opy]: Set default immortality field cooldown":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_BAPTISTE_IMMORTALITY_FIELD_COOLDOWN_TIME)


rule "[baptiste.opy]: Allow self healing during regenerative burst":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.self_healing_percent = 100
    wait(OW1_BAPTISTE_REGEN_BURST_DURATION)
    # waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    eventPlayer.self_healing_percent = 0


rule "[baptiste.opy]: Remove instant healing from regenerative burst":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setHealingDealt(0)
    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    eventPlayer.setHealingDealt(100)


rule "[baptiste.opy]: Buff regenerative burst heals per second":
    @Event playerDealtHealing
    @Hero baptiste
    @Condition eventAbility == Button.ABILITY_1
    @Condition healee == eventPlayer
    
    heal(healee, healer, eventHealing*(OW1_BAPTISTE_REGEN_BURST_SELF_HPS/OW2_BAPTISTE_REGEN_BURST_SELF_HPS)-eventHealing)


rule "[baptiste.opy]: Buff regenerative burst heals per second":
    @Event playerDealtHealing
    @Hero baptiste
    @Condition eventAbility == Button.ABILITY_1
    @Condition healee != eventPlayer
    
    heal(healee, healer, eventHealing*(OW1_BAPTISTE_REGEN_BURST_ALLY_HPS/OW2_BAPTISTE_REGEN_BURST_ALLY_HPS)-eventHealing)
