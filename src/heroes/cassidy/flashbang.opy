#!mainFile "../../main.opy"



rule "[cassidy/flashbang.opy]: OW1 flashbang":
    # playerTookDamage, not playerDealtDamage: this rule waits, and a rule can only run
    # once at a time per event player. Keyed on the attacker, a flash that hits two enemies
    # would only affect one of them; keyed on the victim, each one gets its own instance.
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.CASSIDY
    @Condition eventAbility == Button.ABILITY_2

    eventPlayer.setStatusEffect(attacker, Status.STUNNED, OW1_CASSIDY_FLASHBANG_STUN_DURATION)
    setMoveModifier(eventPlayer, MoveMod.FLASHBANG, 1/OW2_CASSIDY_FLASHBANG_SPEED_REDUCTION)
    wait(OW2_CASSIDY_FLASHBANG_HINDER_DURATION)
    clearMoveModifier(eventPlayer, MoveMod.FLASHBANG)
