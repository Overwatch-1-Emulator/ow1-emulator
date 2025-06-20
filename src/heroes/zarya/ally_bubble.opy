#!mainFile "../../dev_main.opy"

playervar ally_bubble_cooldown
playervar ally_bubble_cd_text

macro initAllyBubble():
    eventPlayer.ally_bubble_cooldown = 0

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
macro showAllyBubbleCD():
    if eventPlayer.ally_bubble_cd_text == null:
        createInWorldText(eventPlayer,
                        "{0}".format(ceil(eventPlayer.ally_bubble_cooldown)),
                        updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((-1.7 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()),
                        verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))),
                        3,
                        Clip.NONE,
                        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
                        Color.WHITE,
                        SpecVisibility.DEFAULT)
        eventPlayer.ally_bubble_cd_text = getLastCreatedText()

macro hideAllyBubbleCD():
    destroyInWorldText(eventPlayer.ally_bubble_cd_text)
    eventPlayer.ally_bubble_cd_text = null


# rule "[zarya/ally_bubble.opy]: OW1 zarya ally bubble cooldown":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition eventPlayer.isUsingAbility2()

#     eventPlayer.disallowButton(Button.ABILITY_2)
#     eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
#     eventPlayer.setAbility2Enabled(false)
#     wait(OW1_ZARYA_BUBBLE_DURATION) # wait bubble duration
#     eventPlayer.ally_bubble_cooldown = OW1_ZARYA_PROJECTED_BARRIER_COOLDOWN_TIME
#     eventPlayer.allowButton(Button.ABILITY_2)
#     chase(eventPlayer.ally_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


# rule "[zarya/ally_bubble.opy]: Disable ally bubble if on cooldown":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition eventPlayer.ally_bubble_cooldown > 0

#     eventPlayer.setAbility2Enabled(false)
#     showAllyBubbleCD()


# rule "[zarya/ally_bubble.opy]: Enable ally bubble if not on cooldown":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition eventPlayer.ally_bubble_cooldown <= 0

#     eventPlayer.setAbility2Enabled(true)
#     hideAllyBubbleCD()

rule "[zarya/barrier.opy]: OW1 Zarya ally barrier health":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0

    eventPlayer.setMaxHealth(percent(OW1_ZARYA_BARRIER_HEALTH/OW2_ZARYA_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2(), TICK_DURATION)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))
