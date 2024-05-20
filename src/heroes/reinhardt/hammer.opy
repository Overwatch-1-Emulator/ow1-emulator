#!mainFile "../../dev_main.opy"


rule "[reinhardt/hammer.opy]: Correct Hammer damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(
        victim, 
        attacker, 
        ((OW1_REINHARDT_HAMMER_DAMAGE/OW2_REINHARDT_HAMMER_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)
