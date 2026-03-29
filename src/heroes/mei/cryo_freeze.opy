#!mainFile "../../main.opy"


rule "[mei/cryo_freeze.opy]: OW1 Cryo-Freeze healing":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setHealingReceived(percent(OW1_MEI_CRYO_HEALING/OW2_MEI_CRYO_HEALING))
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setHealingReceived(100)


rule "[mei/cryo_freeze.opy]: Allow self healing during Cryo-Freeze":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.isUsingAbility1()

    pushSelfHealing(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    popSelfHealing(Button.ABILITY_1)
