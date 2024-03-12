#!mainFile "../../main.opy"


rule "[illari/solar_rifle.opy]: OW1 Solar Rifle headshot damage":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventWasCriticalHit

    damage(
        victim, 
        attacker, 
        ((OW1_ILLARI_RIFLE_HEADSHOT_MULTIPLIER \
        * (eventDamage/OW2_ILLARI_RIFLE_HEADSHOT_MULTIPLIER)) \
        - eventDamage)/eventPlayer._base_damage_scalar)
