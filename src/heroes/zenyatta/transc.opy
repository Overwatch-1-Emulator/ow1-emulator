#!mainFile "../../dev_main.opy"


rule "[zenyatta/transc.opy]: Allow self healing during Transcendence":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZENYATTA
    @Condition eventPlayer.isUsingUltimate()

    pushSelfHealing(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate() == false, Math.INFINITY)
    popSelfHealing(Button.ULTIMATE)
