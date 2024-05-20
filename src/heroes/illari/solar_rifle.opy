#!mainFile "../../dev_main.opy"


rule "[illari/solar_rifle.opy]: OW1 Solar Rifle body damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.ILLARI
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventWasCriticalHit

    damage(
        victim, 
        attacker, 
        ((OW1_ILLARI_SOLAR_RIFLE_DAMAGE/OW2_ILLARI_SOLAR_RIFLE_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)


rule "[illari/solar_rifle.opy]: OW1 Solar Rifle headshot damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.ILLARI
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventWasCriticalHit

    damage(
        victim, 
        attacker, 
        (OW1_ILLARI_SOLAR_RIFLE_CRIT_MULTIPLIER \
        * (OW1_ILLARI_SOLAR_RIFLE_DAMAGE/OW2_ILLARI_SOLAR_RIFLE_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar/OW2_ILLARI_SOLAR_RIFLE_CRIT_MULTIPLIER) \
        - eventDamage)/eventPlayer._base_damage_scalar)
