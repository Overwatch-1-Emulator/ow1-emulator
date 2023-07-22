#!mainFile "../../main.opy"

subroutine initJunkrat

rule "[junkrat.opy]: Detect Junkrat initialization":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initJunkrat()
    eventPlayer.initialized = true


def initJunkrat():
    @Name "[junkrat.opy]: initJunkrat()"
    # Reduce damage to the trap
    eventPlayer.setDamageDealt(percent(OW1_JUNKRAT_STEEL_TRAP_DMG/OW2_JUNKRAT_STEEL_TRAP_DMG))


rule "[junkrat.opy]: Deal extra damage on ability other than steel trap and increase root duration.":
    @Event playerDealtDamage
    @Hero junkrat
    if eventAbility != Button.ABILITY_2 :
        damage(victim, attacker, eventDamage * (OW2_JUNKRAT_STEEL_TRAP_DMG/OW1_JUNKRAT_STEEL_TRAP_DMG) - eventDamage)
    else :
        victim.setStatusEffect(attacker,Status.ROOTED,OW1_JUNKRAT_STEEL_TRAP_DURATION)
