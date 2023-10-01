#!mainFile "../../../main.opy"


rule "[sojourn/init.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.call_init

    resetHero()
    eventPlayer.setDamageDealt(percent(OW1_SOJOURN_GLOBAL_DAMAGE))
    eventPlayer.call_init = false


rule "[sojourn/init.opy]: Deal regular damage for Primary and Melee":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.MELEE]

    # Example on melee
    # expected melee damage: eventDamage*(1/OW1_SOJOURN_GLOBAL_DAMAGE) = 30 dmg
    # actual melee damage: MELEE_DAMAGE * 10% = 30 dmg * 10% = eventDamage = 3 dmg
    # Find additional damage to deal: expected - actual = 27 dmg
    # Multiply by inverse of damage dealt percent scalar (1/OW1_SOJOURN_GLOBAL_DAMAGE) to compensate for game engine damage handling
    damage(victim, attacker, (eventDamage/OW1_SOJOURN_GLOBAL_DAMAGE - eventDamage)/OW1_SOJOURN_GLOBAL_DAMAGE)


#!include "ow1/heroes/sojourn/railgun.opy"
#!include "ow1/heroes/sojourn/slide.opy"
