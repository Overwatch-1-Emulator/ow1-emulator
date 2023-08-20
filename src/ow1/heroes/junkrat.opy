#!mainFile "../../main.opy"

subroutine initJunkrat

rule "[junkrat.opy]: Detect Junkrat initialization":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initJunkrat()
    eventPlayer.call_init = false


def initJunkrat():
    @Name "[junkrat.opy]: initJunkrat()"
    # Reduce damage to the trap
    eventPlayer.setDamageDealt(percent(OW1_JUNKRAT_STEEL_TRAP_DMG/OW2_JUNKRAT_STEEL_TRAP_DMG))


rule "[junkrat.opy]: Deal extra damage on ability other than steel trap and increase root duration.":
    @Event playerDealtDamage
    @Hero junkrat

    if eventAbility == Button.ABILITY_1 :
        # Increase damage for concussion mine
        damage(
            victim,
            attacker,
            (eventDamage
            + (eventDamage - OW1_JUNKRAT_CONCUSSION_MINE_MIN_DAMAGE) 
                / (OW2_JUNKRAT_CONCUSSION_MINE_MAX_DAMAGE - OW2_JUNKRAT_CONCUSSION_MINE_MIN_DAMAGE) 
                * (OW1_JUNKRAT_CONCUSSION_MINE_MAX_DAMAGE - OW2_JUNKRAT_CONCUSSION_MINE_MAX_DAMAGE)
            ) * (OW2_JUNKRAT_STEEL_TRAP_DMG/OW1_JUNKRAT_STEEL_TRAP_DMG) + 1 - eventDamage  # Add 1 to enable one shot combo with trap
        )
        
    elif eventAbility != Button.ABILITY_2 :
        # Increase damage for every ability except trap and conccusion mine
        damage(victim, attacker, eventDamage * (OW2_JUNKRAT_STEEL_TRAP_DMG/OW1_JUNKRAT_STEEL_TRAP_DMG) - eventDamage)
    else :
        # Increase root duration
        victim.setStatusEffect(attacker,Status.ROOTED,OW1_JUNKRAT_STEEL_TRAP_DURATION)
