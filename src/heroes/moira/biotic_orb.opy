#!mainFile "../../main.opy"


playervar orb

rule "[moira/biotic_orb.opy]: OW1 Max Damage Orb":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.ABILITY_2

    eventPlayer.orb = min(eventPlayer.orb + eventDamage, OW1_MOIRA_BIOTIC_ORB_MAX_DAMAGE)

    if eventPlayer.orb >= OW1_MOIRA_BIOTIC_ORB_MAX_DAMAGE:
        heal(eventPlayer, null, OW1_MOIRA_BIOTIC_ORB_HEALING)
        eventPlayer.orb = 0



rule "[moira/init.opy]: OW1 Orb Damage":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_MOIRA_BIOTIC_ORB_DAMAGE/OW2_MOIRA_BIOTIC_ORB_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

