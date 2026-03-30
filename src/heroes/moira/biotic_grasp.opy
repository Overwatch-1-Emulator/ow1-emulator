#!mainFile "../../main.opy"



rule "[moira/biotic_grasp.opy]: OW1 biotic grasp damage":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(victim, null, eventDamage - (OW1_MOIRA_BIOTIC_GRASP_DAMAGE/OW2_MOIRA_BIOTIC_GRASP_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))
