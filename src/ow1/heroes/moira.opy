#!mainFile "../../main.opy"

rule "[moira.opy]: Initialize Moira":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization


rule "[moira.opy]: Deny fade during coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setAbility1Enabled(false)
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.setAbility1Enabled(true)


rule "[moira.opy]: Allow self healing during Biotic Grasp":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, 9999)
    eventPlayer.self_healing_percent = 0


rule "[moira.opy]: Allow self healing during Biotic Orb":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility2()
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.self_healing_percent = 100
    wait(7, Wait.IGNORE_CONDITION)
    eventPlayer.self_healing_percent = 0


rule "[moira.opy]: Allow self healing during Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingUltimate() == false, 9999)
    eventPlayer.self_healing_percent = 0
