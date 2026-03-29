#!mainFile "../../main.opy"


rule "[illari/sun.opy]: Correct Captive Sun direct and splash hit damage":
    @Event playerDealtDamage
    @Hero illari
    @Condition eventAbility in [Button.ULTIMATE]
    @Condition eventDamage/eventPlayer._base_damage_scalar < (OW2_ILLARI_SUNSTRUCK_DAMAGE/2)

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
