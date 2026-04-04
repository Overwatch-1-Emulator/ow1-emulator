#!mainFile "../../main.opy"


rule "[passives/global/global_passive.opy]: Remove DPS passive (Dealing damage reduces enemy healing received)":
    @Event playerDealtDamage
    @Condition eventPlayer.isAlive()

    victim.setHealingReceived(percent(100/(100-(OW2_DAMAGE_PASSIVE_HEAL_REDUCTION_PERCENT if victim.role != Role.TANK else OW2_DAMAGE_PASSIVE_TANK_HEAL_REDUCTION_PERCENT))))
    wait(OW2_DAMAGE_PASSIVE_DURATION, Wait.RESTART_WHEN_TRUE)
    victim.setHealingReceived(100)




rule "[passives/global/armor_passive.opy]: OW1 armor damage reduction correction":
    @Event playerTookDamage
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) > 0
    @Condition attacker != null

    # Skip DoT(Damage Over Time) abilities
    if attacker.getCurrentHero() == Hero.ASHE and eventAbility == Button.ABILITY_2: return
    if attacker.getCurrentHero() == Hero.HANZO and eventAbility == Button.ULTIMATE: return
    if attacker.getCurrentHero() == Hero.MEI and eventAbility == Button.ULTIMATE: return
    if attacker.getCurrentHero() == Hero.MOIRA and eventAbility == Button.ABILITY_2: return
    if attacker.getCurrentHero() == Hero.TORBJORN and eventAbility == Button.ULTIMATE: return
    if attacker.getCurrentHero() == Hero.WIDOWMAKER and eventAbility == Button.ABILITY_2: return
    if attacker.getCurrentHero() == Hero.ZARYA and eventAbility == Button.ULTIMATE: return

    # Skip beam abilities cause it already applies
    if attacker.getCurrentHero() == Hero.ECHO and eventAbility == Button.ABILITY_1: return
    if attacker.getCurrentHero() == Hero.MEI and eventAbility == Button.PRIMARY_FIRE: return
    if attacker.getCurrentHero() == Hero.MOIRA and eventAbility == Button.SECONDARY_FIRE: return
    if attacker.getCurrentHero() == Hero.MOIRA and eventAbility == Button.ULTIMATE: return
    if attacker.getCurrentHero() == Hero.SYMMETRA and eventAbility == Button.PRIMARY_FIRE: return
    if attacker.getCurrentHero() == Hero.SYMMETRA and eventAbility == Button.ABILITY_2: return
    if attacker.getCurrentHero() == Hero.ZARYA and eventAbility == Button.PRIMARY_FIRE: return

    # Winston: OW1 Beam
    if attacker.getCurrentHero() == Hero.WINSTON and eventAbility == Button.PRIMARY_FIRE:
        heal(eventPlayer, null, eventDamage * OW1_ARMOR_BEAM_DAMAGE_REDUCTION)
        return
    # OW1 Armor Reduction
    if eventDamage >= OW2_ARMOR_DAMAGE_REDUCTION:
        damage(eventPlayer, attacker, (((eventDamage + (OW2_ARMOR_DAMAGE_REDUCTION - OW1_ARMOR_DAMAGE_REDUCTION) * 2) / eventDamage) * (eventDamage / attacker._base_damage_scalar) - eventDamage) / attacker._base_damage_scalar)

