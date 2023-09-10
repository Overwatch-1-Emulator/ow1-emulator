#!mainFile "../../../main.opy"


rule "[moira.opy]: Allow self healing during Biotic Grasp":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.self_healing_source.append(Button.SECONDARY_FIRE)
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, Math.INFINITY)
    eventPlayer.self_healing_source.remove(Button.SECONDARY_FIRE)


rule "[moira.opy]: Allow self healing during Biotic Orb":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility2()
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.self_healing_source.append(Button.ABILITY_2)
    wait(7, Wait.IGNORE_CONDITION)
    eventPlayer.self_healing_source.remove(Button.ABILITY_2)


rule "[moira.opy]: Allow self healing during Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.self_healing_source.append(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate() == false, Math.INFINITY)
    eventPlayer.self_healing_source.remove(Button.ULTIMATE)
