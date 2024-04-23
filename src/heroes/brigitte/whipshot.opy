#!mainFile "../../dev_main.opy"


rule "[brigitte/init.opy]: Correct Whipshot damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)


# rule "[brigitte/whipshot.opy]: Reduce Whip Shot damage to OW1":
#     @Event playerDealtDamage
#     @Hero brigitte
#     @Condition eventAbility == Button.ABILITY_1

#     heal(victim, null, eventDamage - eventDamage*(OW1_BRIGITTE_WHIPSHOT_DAMAGE/OW2_BRIGITTE_WHIPSHOT_DAMAGE))
