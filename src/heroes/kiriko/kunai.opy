#!mainFile "../../../main.opy"


rule "[kiriko/kunai.opy]: OW1 Kunai headshot damage":
    @Event playerDealtDamage
    @Hero kiriko
    # @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventAbility == null # Workshop bug: Kunai event Ability = null instead of secondary fire
    @Condition eventWasCriticalHit

    damage(victim, attacker, (OW1_KIRIKO_KUNAI_HEADSHOT_MULTIPLIER*(eventDamage/OW2_KIRIKO_KUNAI_HEADSHOT_MULTIPLIER) - eventDamage)/OW1_KIRIKO_GLOBAL_DAMAGE)
