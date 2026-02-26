#!mainFile "../../dev_main.opy"

#playervar self_bubble_cooldown
#playervar self_bubble_cd_text

#macro initSelfBubble():
#    eventPlayer.self_bubble_cooldown = 0

/*
Below HUD code is sourced from https://workshop.codes/wiki/articles/rendering-an-inworld-text-at-a-specific-onscreen-position

This HUD works by placing a in-world-text visible to only the zarya player.
The reason for doing this is to place the UI anywhere on the screen. 

Currently, HUD texts can only be placed on the top left/middle/right of the screen.
There's ways to move the text down to the bottom right using many new lines "\r\n" character,
but I personally don't like this approach, and find the in world text more elegant.

Because the text exists in the game world, when the player performs activities that shake the camera,
such as meleeing or reloading, the HUD moves/shakes around with the camera.

Below HUD is tuned for 16:9 aspect ratio monitors (typical PC Overwatch setup).
*/
#macro showSelfBubbleCD():
#    if eventPlayer.self_bubble_cd_text == null:
#        createInWorldText(eventPlayer,
#                        "{0}".format(ceil(eventPlayer.self_bubble_cooldown)),
#                        updateEveryTick(eventPlayer.getEyePosition() + (100 * (1.99 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((-1.7 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()),
#                        verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))),
#                        3,
#                        Clip.NONE,
#                        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
#                        Color.WHITE,
#                        SpecVisibility.DEFAULT)
#        eventPlayer.self_bubble_cd_text = getLastCreatedText()

#macro hideSelfBubbleCD():
#    destroyInWorldText(eventPlayer.self_bubble_cd_text)
#    eventPlayer.self_bubble_cd_text = null


# rule "[zarya/self_bubble.opy]: OW1 zarya self bubble cooldown":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition eventPlayer.isUsingAbility1()
    
#     eventPlayer.disallowButton(Button.ABILITY_1)
#     eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
#     waitUntil(not eventPlayer.isUsingAbility1(), OW1_ZARYA_BUBBLE_DURATION) # wait bubble duration
#     eventPlayer.setAbility1Enabled(false)
#     eventPlayer.self_bubble_cooldown = OW1_ZARYA_PARTICLE_BARRIER_COOLDOWN_TIME
#     eventPlayer.allowButton(Button.ABILITY_1)
#     chase(eventPlayer.self_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


# rule "[zarya/self_bubble.opy]: Disable self bubble if on cooldown":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition eventPlayer.self_bubble_cooldown > 0

#     eventPlayer.setAbility1Enabled(false)
#     showSelfBubbleCD()


# rule "[zarya/self_bubble.opy]: Enable self bubble if not on cooldown":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition eventPlayer.self_bubble_cooldown <= 0

#     eventPlayer.setAbility1Enabled(true)
#     hideSelfBubbleCD()


rule "[zarya/barrier.opy]: OW1 Zarya self barrier health":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0

    eventPlayer.setMaxHealth(percent(OW1_ZARYA_BARRIER_HEALTH/OW2_ZARYA_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), TICK_DURATION)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
