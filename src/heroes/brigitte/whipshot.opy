# #!mainFile "../../main.opy"


# rule "[brigitte/whipshot.opy]: Reduce Whip Shot damage to OW1":
#     @Event playerDealtDamage
#     @Hero brigitte
#     @Condition eventAbility == Button.ABILITY_1

#     heal(victim, null, eventDamage - eventDamage*(OW1_BRIGITTE_WHIPSHOT_DAMAGE/OW2_BRIGITTE_WHIPSHOT_DAMAGE))
