#!mainFile "../../../main.opy"


rule "[sojourn/init.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.call_init

    resetHero()
    eventPlayer.setDamageDealt(OW1_SOJOURN_SAFETY_NET)
    eventPlayer.call_init = false


rule "[sojourn/init.opy]: Deal correct melee and disruptor damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility in [Button.MELEE, Button.ABILITY_2]

    # Example on melee
    # expected melee damage: eventDamage*(100/OW1_SOJOURN_SAFETY_NET) = 30 dmg
    # actual melee damage: MELEE_DAMAGE * 10% = 30 dmg * 10% = eventDamage = 3 dmg
    # Find additional damage to deal: expected - actual = 27 dmg
    # Multiply by inverse of damage dealt percent scalar (100/OW1_SOJOURN_SAFETY_NET) to compensate for game engine damage handling
    damage(victim, attacker, (100/OW1_SOJOURN_SAFETY_NET)*(eventDamage*(100/OW1_SOJOURN_SAFETY_NET) - eventDamage))


#!include "ow1/heroes/sojourn/railgun.opy"