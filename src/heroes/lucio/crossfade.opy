#!mainFile "../../main.opy"


rule "[lucio/crossfade.opy]: OW1 Ally Healing":
    @Event playerDealtHealing
    @Hero lucio
    @Condition eventAbility == Button.ABILITY_1

    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar*(OW1_LUCIO_ALLY_HEALING/OW2_LUCIO_ALLY_HEALING)-eventHealing)


rule "[lucio/crossfade.opy]: AMPED UP Correct Healing":
    @Event playerDealtHealing
    @Hero lucio
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setHealingDealt(percent(OW1_LUCIO_AMP_SELF_HEALING/OW2_LUCIO_AMP_HEALING))
    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar*(OW1_LUCIO_AMP_ALLY_HEALING/OW2_LUCIO_AMP_HEALING)-eventHealing)
    waitUntil(not eventPlayer.isUsingAbility2(), Math.INFINITY)
    eventPlayer.setHealingDealt(percent(eventPlayer._base_healing_scalar))