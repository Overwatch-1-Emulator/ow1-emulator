#!mainFile "../../main.opy"


rule "[reinhardt/hammer.opy]: Deal regular damage for Fire Strike":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition eventAbility in [Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/OW1_REINHARDT_GLOBAL_DAMAGE - eventDamage)/OW1_REINHARDT_GLOBAL_DAMAGE)
