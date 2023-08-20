#!mainFile "../../main.opy"

playervar self_bubble_cooldown
playervar ally_bubble_cooldown

playervar self_bubble_cd_text
playervar ally_bubble_cd_text

subroutine initZarya
subroutine showSelfBubbleCD
subroutine hideSelfBubbleCD
subroutine showAllyBubbleCD
subroutine hideAllyBubbleCD

rule "[zarya.opy]: Detect Zarya initialization":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initZarya()
    eventPlayer.call_init = false


def initZarya():
    @Name "[zarya.opy]: initZarya()"

    do:
        clearCustomHealth()
        setCustomHealth(OW1_ZARYA_HEALTH, 0, OW1_ZARYA_SHIELDS)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_ZARYA_HEALTH + OW1_ZARYA_SHIELDS)

    eventPlayer.self_bubble_cooldown = 0
    eventPlayer.ally_bubble_cooldown = 0

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))

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
def showSelfBubbleCD():
    @Name "[zarya.opy]: showSelfBubbleCD()"
    
    createInWorldText(eventPlayer, 
                      "{0}".format(ceil(eventPlayer.self_bubble_cooldown)),
                      updateEveryTick(eventPlayer.getEyePosition() + (100 * (1.99 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((-1.44 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
                      verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
                      3, 
                      Clip.NONE, 
                      WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
                      Color.WHITE, 
                      SpecVisibility.DEFAULT)
    eventPlayer.self_bubble_cd_text = getLastCreatedText()
    eventPlayer.text_huds.append(eventPlayer.self_bubble_cd_text)

def hideSelfBubbleCD():
    @Name "[zarya.opy]: hideSelfBubbleCD()"

    destroyInWorldText(eventPlayer.self_bubble_cd_text)
    eventPlayer.text_huds.remove(eventPlayer.self_bubble_cd_text)


def showAllyBubbleCD():
    @Name "[zarya.opy]: showAllyBubbleCD()"

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
    eventPlayer.text_huds.append(eventPlayer.ally_bubble_cd_text)

def hideAllyBubbleCD():
    @Name "[zarya.opy]: hideAllyBubbleCD()"

    destroyInWorldText(eventPlayer.ally_bubble_cd_text)
    eventPlayer.text_huds.remove(eventPlayer.ally_bubble_cd_text)


rule "[zarya.opy]: OW1 zarya self bubble cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
    eventPlayer.setAbility1Enabled(false)
    wait(OW1_ZARYA_BUBBLE_DURATION) # 2 second bubble duration
    eventPlayer.self_bubble_cooldown = OW1_ZARYA_PARTICLE_BARRIER_COOLDOWN_TIME
    chase(eventPlayer.self_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


rule "[zarya.opy]: OW1 zarya ally bubble cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.setAbility2Enabled(false)
    wait(OW1_ZARYA_BUBBLE_DURATION) # 2 second bubble duration
    eventPlayer.ally_bubble_cooldown = OW1_ZARYA_PROJECTED_BARRIER_COOLDOWN_TIME
    chase(eventPlayer.ally_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


rule "[zarya.opy]: Disable self bubble if on cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.self_bubble_cooldown > 0

    eventPlayer.setAbility1Enabled(false)


rule "[zarya.opy]: Disable ally bubble if on cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.ally_bubble_cooldown > 0

    eventPlayer.setAbility2Enabled(false)


rule "[zarya.opy]: Enable self bubble if not on cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.self_bubble_cooldown <= 0

    eventPlayer.setAbility1Enabled(true)


rule "[zarya.opy]: Enable ally bubble if not on cooldown":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.ally_bubble_cooldown <= 0

    eventPlayer.setAbility2Enabled(true)


rule "[zarya.opy]: Draw self bubble cooldown":
    @Event eachPlayer
    @Condition eventPlayer.self_bubble_cooldown > 0

    showSelfBubbleCD()


rule "[zarya.opy]: Erase self bubble cooldown":
    @Event eachPlayer
    @Condition eventPlayer.self_bubble_cooldown <= 0

    hideSelfBubbleCD()


rule "[zarya.opy]: Draw self bubble cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown > 0

    showAllyBubbleCD()


rule "[zarya.opy]: Erase self bubble cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown <= 0

    hideAllyBubbleCD()
