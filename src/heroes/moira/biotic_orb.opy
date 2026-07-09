#!mainFile "../../main.opy"


playervar orb_damage_dealt

rule "[moira/biotic_orb.opy]: Reset orb damage total on new orb":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.orb_damage_dealt = 0


rule "[moira/biotic_orb.opy]: OW1 orb total damage cap":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.MOIRA
    @Condition eventAbility == Button.ABILITY_2

    attacker.orb_damage_dealt += eventDamage
    if attacker.orb_damage_dealt > OW1_MOIRA_BIOTIC_ORB_MAX_DAMAGE:
        print(attacker.orb_damage_dealt)
        #heal(victim, null, min(eventDamage, attacker.orb_damage_dealt - OW1_MOIRA_BIOTIC_ORB_MAX_DAMAGE))



rule "[moira/init.opy]: OW1 Orb Damage":
    @Event playerDealtDamage
    @Hero moira
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_MOIRA_BIOTIC_ORB_DAMAGE/OW2_MOIRA_BIOTIC_ORB_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)

