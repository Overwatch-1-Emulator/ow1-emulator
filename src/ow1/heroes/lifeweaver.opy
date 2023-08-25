#!mainFile "../../main.opy"

rule "[lifeweaver.opy]: Initialize Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization


rule "[lifeweaver.opy]: Allow self healing during Rejuvanating Dash":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isJumping() # [TODO] Replace with better condition

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isJumping() == false, 9999) # [TODO] Replace with better condition
    eventPlayer.self_healing_percent = 0


rule "[lifeweaver.opy]: Allow self healing during Tree of Life":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingUltimate() == false, 9999)
    eventPlayer.self_healing_percent = 0
