#!mainFile "../../dev_main.opy"


rule "[passives/tank/headshot.opy]: OW1 tank headshot damage":
    @Event playerDealtDamage
    @Condition eventWasCriticalHit
    @Condition victim.getCurrentHero() in getTankHeroes()

    damage(
        victim, 
        attacker, 
        ((CRITICAL_HIT_MULTIPLIER/OW2_TANK_CRITICAL_HIT_MULTIPLIER)*(eventDamage/attacker._base_damage_scalar) - eventDamage)/attacker._base_damage_scalar)
