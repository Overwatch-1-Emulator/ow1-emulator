#!mainFile "../../../main.opy"


rule "[moira/self_heal.opy]: Allow self healing during Biotic Grasp":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isFiringSecondaryFire()

    pushSelfHealing(Button.SECONDARY_FIRE)
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, Math.INFINITY)
    popSelfHealing(Button.SECONDARY_FIRE)


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
