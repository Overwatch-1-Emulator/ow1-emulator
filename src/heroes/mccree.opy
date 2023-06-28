#!include "ow1_constants.opy"

playervar flashbang_origin_position

rule "Store flashbang origin position":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.flashbang_origin_position = eventPlayer.getEyePosition()

rule "Remove magnetic grenade effects":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.MCCREE
    @Condition eventAbility == Button.ABILITY_2

    heal(eventPlayer, null, eventDamage)
    if distance(eventPlayer.getPosition(), attacker.flashbang_origin_position) <= ow1_flashbang_max_range:
        eventPlayer.setStatusEffect(attacker, Status.STUNNED, ow1_flashbang_stun_duration)
    else:
        eventPlayer.clearStatusEffect(Status.STUNNED)