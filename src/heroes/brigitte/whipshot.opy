# #!mainFile "../../dev_main.opy"


# rule "[brigitte/whipshot.opy]: Reduce Whip Shot damage to OW1":
#     @Event playerDealtDamage
#     @Condition eventPlayer._hero_setup == Hero.BRIGITTE
#     @Condition eventAbility == Button.ABILITY_1

#     heal(victim, null, eventDamage - eventDamage*(OW1_BRIGITTE_WHIPSHOT_DAMAGE/OW2_BRIGITTE_WHIPSHOT_DAMAGE))
