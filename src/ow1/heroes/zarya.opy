#!mainFile "../../main.opy"

playervar self_bubble_cooldown
playervar ally_bubble_cooldown
playervar zarya_hud_visibility

subroutine initZarya

rule "[zarya.opy]: Initialize Zarya":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initZarya()
    eventPlayer.initialized = true


def initZarya():
    @Name "[zarya.opy]: initZarya()"

    do:
        clearCustomHealth()
        setCustomHealth(OW1_ZARYA_HEALTH, 0, OW1_ZARYA_SHIELDS)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_ZARYA_HEALTH + OW1_ZARYA_SHIELDS)

    eventPlayer.self_bubble_cooldown = 0
    eventPlayer.ally_bubble_cooldown = 0
    eventPlayer.zarya_hud_visibility = eventPlayer

    /*
    Below HUD code is sourced from https://workshop.codes/wiki/articles/rendering-an-inworld-text-at-a-specific-onscreen-position

    This HUD works by placing a in-world-text visible to only the zarya player.
    The reason for doing this is to place the UI anywhere on the screen. 

    Currently, HUD texts can only be placed on the top left/middle/right of the screen.
    There's ways to move the text down to the bottom right using many many empty new lines, etc,
    but imo this approach is the cleanest by placing the text in the game world.

    Because the text exsits in the game world, when the player performs activities that shake the camera,
    such as meleeing or reloading, the HUD moves/shakes around with the camera.

    Below HUD is tuned for 16:9 aspect ratio monitors (typical PC Overwatch setup).
    */
    createInWorldText(eventPlayer.zarya_hud_visibility, 
                      "{0}    {1}".format(ceil(eventPlayer.self_bubble_cooldown), ceil(eventPlayer.ally_bubble_cooldown)), 
                      updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.15 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((-1.45 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
                      verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
                      4, 
                      Clip.NONE, 
                      WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
                      Color.WHITE, 
                      SpecVisibility.DEFAULT)
    eventPlayer.text_huds.append(getLastCreatedText())


rule "[zarya.opy]: Hide bubble cooldown HUD on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true
    @Condition eventPlayer.getCurrentHero() != Hero.ZARYA

    eventPlayer.zarya_hud_visibility = null


rule "[zarya.opy]: zarya self bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
    eventPlayer.setAbility1Enabled(false)
    wait(2) # 2 second bubble duration
    eventPlayer.self_bubble_cooldown = OW1_ZARYA_PARTICLE_BARRIER_COOLDOWN_TIME
    chase(eventPlayer.self_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.self_bubble_cooldown == 0, OW1_ZARYA_PARTICLE_BARRIER_COOLDOWN_TIME)
    eventPlayer.setAbility1Enabled(true)


rule "[zarya.opy]: zarya ally bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.setAbility2Enabled(false)
    wait(2) # 2 second bubble duration
    eventPlayer.ally_bubble_cooldown = OW1_ZARYA_PROJECTED_BARRIER_COOLDOWN_TIME
    chase(eventPlayer.ally_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.ally_bubble_cooldown == 0, OW1_ZARYA_PROJECTED_BARRIER_COOLDOWN_TIME)
    eventPlayer.setAbility2Enabled(true)
