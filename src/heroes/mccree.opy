#!include "ow1_constants.opy"

playervar flashbang_origin_position
playervar flashbang_exploded

rule "Disable magnetic grenade":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0

    eventPlayer.setAbility2Enabled(false)

rule "Store flashbang origin position":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.flashbang_origin_position = eventPlayer.getEyePosition()
    eventPlayer.flashbang_exploded = false

rule "Remove all damage from magnetic grenade":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) == false

    eventPlayer.setDamageDealt(0.001)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.setDamageDealt(100)

rule "Remove all effects from magnetic grenade":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.MCCREE
    @Condition eventAbility == Button.ABILITY_2

    heal(eventPlayer, null, eventDamage) # heal all damage inflicted by grenade
    eventPlayer.clearStatusEffect(Status.STUNNED) # remove any cc inflicted by grenade

rule "Stun flashed enemy":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.MCCREE
    @Condition victim != attacker
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.flashbang_exploded == false # without this the enemy is stunned twice
    @Condition distance(eventPlayer.getPosition(), attacker.flashbang_origin_position) <= ow1_flashbang_max_range

    damage(eventPlayer, attacker, ow1_flashbang_damage)
    eventPlayer.setStatusEffect(attacker, Status.STUNNED, ow1_flashbang_stun_duration)
    attacker.flashbang_exploded = true
