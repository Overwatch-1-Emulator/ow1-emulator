#!mainFile "../../main.opy"

playervar self_bubble_cooldown
playervar self_bubble_cd_text
playervar ally_bubble_cooldown
playervar ally_bubble_cd_text

subroutine initSelfBubble
subroutine initAllyBubble


rule "Zarya":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    eventPlayer.addHealthPool(Health.SHIELDS, 150 if eventPlayer.isDuplicatingAHero() or Setting_echo_tank_hp else 200, true, true)
    initSelfBubble()
    initAllyBubble()
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    eventPlayer.setKnockbackDealt(73.607)
    eventPlayer.setDamageDealt(84.211)


rule "Increase Zarya Alternate Fire and melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition (eventAbility == Button.MELEE or eventAbility == Button.SECONDARY_FIRE) == true
    
    damage(victim, attacker, eventDamage * 1.188 - eventDamage)


def initSelfBubble():
    @Name "initSelfBubble()"
    
    eventPlayer.self_bubble_cooldown = 0


def showSelfBubbleCD():
    @Name "showSelfBubbleCD()"
    
    createInWorldText(eventPlayer, "{0}".format(ceil(eventPlayer.self_bubble_cooldown)), updateEveryTick(eventPlayer.getEyePosition() + (100 * (1.99 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + (-1.64 * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.self_bubble_cd_text = getLastCreatedText()


def hideSelfBubbleCD():
    @Name "hideSelfBubbleCD()"
    
    destroyInWorldText(eventPlayer.self_bubble_cd_text)


rule "Set Particle Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 2)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.self_bubble_cooldown = 12
    chase(eventPlayer.self_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


rule "Disable Particle Barrier if on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.self_bubble_cooldown > 0
    
    eventPlayer.setAbility1Enabled(false)


rule "Enable Particle Barrier if not on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.self_bubble_cooldown <= 0
    
    eventPlayer.setAbility1Enabled(true)


rule "Show Particle Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.self_bubble_cooldown > 0
    
    showSelfBubbleCD()


rule "Erase Particle Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.self_bubble_cooldown <= 0
    
    hideSelfBubbleCD()


def initAllyBubble():
    @Name "initAllyBubble()"
    
    eventPlayer.ally_bubble_cooldown = 0


def showAllyBubbleCD():
    @Name "showAllyBubbleCD()"
    
    createInWorldText(eventPlayer, "{0}".format(ceil(eventPlayer.ally_bubble_cooldown)), updateEveryTick(eventPlayer.getEyePosition() + (100 * (2.3 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + (-1.66 * (angleToDirection(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)
    eventPlayer.ally_bubble_cd_text = getLastCreatedText()


def hideAllyBubbleCD():
    @Name "hideAllyBubbleCD()"
    
    destroyInWorldText(eventPlayer.ally_bubble_cd_text)


rule "Set Projected Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbilityCharge(Button.ABILITY_2, 2)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.ally_bubble_cooldown = 10
    chase(eventPlayer.ally_bubble_cooldown, 0, rate=1, ChaseReeval.NONE)


rule "Disable Projected Barrier if on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.ally_bubble_cooldown > 0
    
    eventPlayer.setAbility2Enabled(false)


rule "Enable Projected Barrier if not on cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ZARYA
    @Condition eventPlayer.ally_bubble_cooldown <= 0
    
    eventPlayer.setAbility2Enabled(true)


rule "Show Projected Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown > 0
    
    showAllyBubbleCD()


rule "Erase Projected Barrier cooldown":
    @Event eachPlayer
    @Condition eventPlayer.ally_bubble_cooldown <= 0
    
    hideAllyBubbleCD()


rule "Clean up Zarya":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup != Hero.ZARYA
    
    hideSelfBubbleCD()
    hideAllyBubbleCD()
