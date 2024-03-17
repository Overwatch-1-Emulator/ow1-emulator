#!mainFile "../../dev_main.opy"

playervar biotic_grasp_pvar
#!defineMember _moira_hp_before biotic_grasp_pvar[0]


# rule "[moira/biotic_grasp.opy]: Allow self healing during Biotic Grasp":
#     @Event playerDealtDamage
#     @Hero moira
#     @Condition eventAbility == Button.SECONDARY_FIRE

#     eventPlayer._moira_hp_before = eventPlayer.getHealth()
#     heal(eventPlayer, eventPlayer, eventDamage*(OW1_MOIRA_BIOTIC_GRASP_HEALING/OW1_MOIRA_BIOTIC_GRASP_DAMAGE))
#     eventPlayer._missing_ult_points += eventPlayer.getHealth() - eventPlayer._moira_hp_before


rule "[moira/biotic_grasp.opy]: OW1 biotic grasp damage":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(victim, null, eventDamage - eventDamage*(OW1_MOIRA_BIOTIC_GRASP_DAMAGE/OW2_MOIRA_BIOTIC_GRASP_DAMAGE))
