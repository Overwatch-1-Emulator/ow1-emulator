#!mainFile "../../main.opy"

playervar ally_bubble_cooldown
playervar ally_bubble_cd_text

subroutine initAllyBubble
subroutine showAllyBubbleCD
subroutine hideAllyBubbleCD


def initAllyBubble():
    @Name "[zarya/ally_bubble.opy]: initAllyBubble()"

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
def showAllyBubbleCD():
    @Name "[zarya/ally_bubble.opy]: showAllyBubbleCD()"

    createInWorldText(eventPlayer, 
                      "{0}".format(ceil(eventPlayer.ally_bubble_cooldown)),
                      updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((-1.46 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
                      verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
                      3, 
                      Clip.NONE, 
                      WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
                      Color.WHITE, 
                      SpecVisibility.DEFAULT)
    eventPlayer.ally_bubble_cd_text = getLastCreatedText()


def hideAllyBubbleCD():
    @Name "[zarya/ally_bubble.opy]: hideAllyBubbleCD()"

    destroyInWorldText(eventPlayer.ally_bubble_cd_text)


rule "[zarya/ally_bubble.opy]: OW1 zarya ally bubble cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.setAbility2Enabled(false)
    wait(OW1_ZARYA_BUBBLE_DURATION) # 2 second bubble duration
    eventPlayer.ally_bubble_cooldown = OW1_ZARYA_PROJECTED_BARRIER_COOLDOWN_TIME
    chase(eventPlayer.ally_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


rule "[zarya/ally_bubble.opy]: Disable ally bubble if on cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.ally_bubble_cooldown > 0

    eventPlayer.setAbility2Enabled(false)


rule "[zarya/ally_bubble.opy]: Enable ally bubble if not on cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.ally_bubble_cooldown <= 0

    eventPlayer.setAbility2Enabled(true)


rule "[zarya/ally_bubble.opy]: Show ally bubble cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown > 0

    showAllyBubbleCD()


rule "[zarya/ally_bubble.opy]: Erase ally bubble cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown <= 0

    hideAllyBubbleCD()
