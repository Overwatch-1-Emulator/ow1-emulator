#!mainFile "../../main.opy"


rule "[ana/nade.opy]: Heal OW1 healing with biotic grenade":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2

    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar*(OW1_ANA_BIOTIC_GRENADE_HEALING/OW2_ANA_BIOTIC_GRENADE_HEALING)-eventHealing)

