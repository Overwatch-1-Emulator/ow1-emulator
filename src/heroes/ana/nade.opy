#!mainFile "../../main.opy"

playervar ana_nade_ally
#!defineMember ana_nade_enmemy ana_nade_ally[0]

rule "[ana/nade.opy]: Heal OW1 healing with biotic grenade":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2

    heal(healee, healer, eventHealing/eventPlayer._base_healing_scalar*(OW1_ANA_BIOTIC_GRENADE_HEALING/OW2_ANA_BIOTIC_GRENADE_HEALING)-eventHealing)

rule "[ana/nade.opy]: Damage OW1 damage with biotic grenade":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ANA_BIOTIC_GRENADE_DAMAGE/OW2_ANA_BIOTIC_GRENADE_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    victim.ana_nade_enmemy = true

rule "[ana/nade.opy]: Detect Ally With Healing":
    @Event playerReceivedHealing
    @Condition healee == Hero.ANA
    @Condition eventAbility == Button.ABILITY_2

    eventPlayer.ana_nade_ally = true


rule "[ana/nade.opy]: OW1 Ana Nade Duration":
    @Event eachPlayer
    @Condition eventPlayer.ana_nade_ally == true or eventPlayer.ana_nade_enmemy == true

    if eventPlayer.ana_nade_ally == true:
        eventPlayer.setHealingReceived(percent(100/(100-(OW1_ANA_BIOTIC_GRENADE_HEAL_BOOST))))
    else:
        eventPlayer.setHealingReceived(0)
    wait(OW1_ANA_BIOTIC_GRENADE_DURATION)
    if eventPlayer.ana_nade_ally == true:
        eventPlayer.ana_nade_ally = false
    elif  eventPlayer.ana_nade_enmemy == true:
        eventPlayer.ana_nade_ally = false