#!mainFile "../../../main.opy"


rule "[lifeweaver/init.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.call_init
    
    defaultHero()
    # removeSelfHealing()
    eventPlayer.call_init = false


rule "[lifeweaver.opy]: Allow self healing during Rejuvanating Dash":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isJumping() # [TODO] Replace with better condition

    pushSelfHealing(Button.JUMP)
    waitUntil(eventPlayer.isJumping() == false, Math.INFINITY) # [TODO] Replace with better condition
    popSelfHealing(Button.JUMP)


rule "[lifeweaver.opy]: Allow self healing during Tree of Life":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isUsingUltimate()

    pushSelfHealing(Button.ULTIMATE)
    waitUntil(eventPlayer.isUsingUltimate() == false, Math.INFINITY)
    popSelfHealing(Button.ULTIMATE)