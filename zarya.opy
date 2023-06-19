#!include "ow1_constants.opy"

playervar self_bubble_cooldown
playervar ally_bubble_cooldown

rule "set bubble variables":
    @Event eachPlayer
    @Hero zarya

    eventPlayer.self_bubble_cooldown = 0
    eventPlayer.ally_bubble_cooldown = 0
    # hudHeader(eventPlayer, l"{0} {1}".format(ceil(eventPlayer.self_bubble_cooldown), ceil(eventPlayer.ally_bubble_cooldown)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    createInWorldText(eventPlayer, 
                      "{0}            {1}".format(ceil(eventPlayer.self_bubble_cooldown), 
                      ceil(eventPlayer.ally_bubble_cooldown)), 
                      updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.15 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + ((-0.9 - 0.2) * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), 
                      verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 
                      2, 
                      Clip.NONE, 
                      WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
                      Color.RED, 
                      SpecVisibility.DEFAULT)
  
rule "zarya self bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility1()
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
    eventPlayer.setAbility1Enabled(false)
    wait(2) # 2 second bubble duration
    eventPlayer.self_bubble_cooldown = ow1_cooldown_ability1_ZARYA
    chase(eventPlayer.self_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.self_bubble_cooldown == 0, ow1_cooldown_ability1_ZARYA)
    eventPlayer.setAbility1Enabled(true)

rule "zarya ally bubble":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.setAbility2Enabled(false)
    wait(2) # 2 second bubble duration
    eventPlayer.ally_bubble_cooldown = ow1_cooldown_ability2_ZARYA
    chase(eventPlayer.ally_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)
    waitUntil(eventPlayer.ally_bubble_cooldown == 0, ow1_cooldown_ability2_ZARYA)
    eventPlayer.setAbility2Enabled(true)