#!mainFile "../../main.opy"

playervar moira_self_heal_pvar
#!defineMember _moira_hp_before moira_self_heal_pvar[0]


rule "[moira/self_heal.opy]: Allow self healing during Biotic Grasp":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.SECONDARY_FIRE

    eventPlayer._moira_hp_before = eventPlayer.getHealth()
    heal(eventPlayer, eventPlayer, eventDamage*(OW1_MOIRA_BIOTIC_GRASP_HEALING/OW1_MOIRA_BIOTIC_GRASP_DAMAGE))
    eventPlayer._missing_ult_points += eventPlayer.getHealth() - eventPlayer._moira_hp_before


rule "[moira/self_heal.opy]: Allow self healing during Biotic Orb":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility2()
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    pushSelfHealing(Button.ABILITY_2)
    wait(7, Wait.IGNORE_CONDITION)
    popSelfHealing(Button.ABILITY_2)


rule "[moira/self_heal.opy]: Allow self healing during Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    pushSelfHealing(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate() == false, Math.INFINITY)
    popSelfHealing(Button.ULTIMATE)
