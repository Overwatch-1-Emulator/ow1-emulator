#!mainFile "../main.opy"

playervar hero_setup
playervar hero_check


rule "[utilities/hero_switch]: Check for hero setup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup != eventPlayer.getCurrentHero()
    @Condition not eventPlayer.isDuplicatingAHero()
    @Condition not isMatchBetweenRounds()
    @Condition eventPlayer.isAlive()
    
    #This wait time may be needed for some gameodes 
    #wait(0.024)
    eventPlayer.hero_setup = eventPlayer.getCurrentHero()


rule "[utilities/hero_switch]: Check for hero change":
    @Event eachPlayer
    @Condition eventPlayer.hero_check != eventPlayer.getCurrentHero()
    
    #This wait time may be needed for some gameodes 
    #wait(0.024)
    eventPlayer.hero_check = eventPlayer.getCurrentHero()
    resetUltCharge()


rule "[utilities/reset.opy]: Hero reset on death":
    @Event playerDied
    
    eventPlayer.hero_setup = -1


rule "[utilities/reset.opy]: Hero reset after round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    
    eventPlayer.hero_setup = -1


/*
rule "Hero reset after game starts (needed for gamemodes with no hero select/bots)":
    @Event eachPlayer
    @Condition isInSetup() == true
    
    eventPlayer.hero_setup = -1
*/
