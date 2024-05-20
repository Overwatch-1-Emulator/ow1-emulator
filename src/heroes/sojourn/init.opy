#!mainFile "../../dev_main.opy"

#!include "heroes/sojourn/railgun.opy"


rule "[sojourn/init.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.SOJOURN
    @Condition eventPlayer._call_init

    setCustomHp(OW1_SOJOURN_HEALTH, 0, 0)
    setUltCost(OW1_SOJOURN_ULT_COST)
    setBaseDamage(eventPlayer, OW1_SOJOURN_GLOBAL_DAMAGE)
    
    removeSelfHealing()

    eventPlayer._call_init = false


rule "[sojourn/init.opy]: Deal regular damage for Primary and Melee":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.SOJOURN
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.MELEE]

    # Example on melee
    # expected melee damage: eventDamage*(1/OW1_SOJOURN_GLOBAL_DAMAGE) = 30 dmg
    # actual melee damage: MELEE_DAMAGE * 10% = 30 dmg * 10% = eventDamage = 3 dmg
    # Find additional damage to deal: expected - actual = 27 dmg
    # Multiply by inverse of damage dealt percent scalar (1/OW1_SOJOURN_GLOBAL_DAMAGE) to compensate for game engine damage handling
    damage(victim, attacker, (eventDamage/OW1_SOJOURN_GLOBAL_DAMAGE - eventDamage)/OW1_SOJOURN_GLOBAL_DAMAGE)


# #!include "heroes/sojourn/slide.opy"
