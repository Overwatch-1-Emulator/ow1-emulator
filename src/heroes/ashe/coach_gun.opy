#!mainFile "../../dev_main.opy"


rule "[ashe/coach_gun.opy]: Compensate Ashe global damage reduction":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, ((9/6)*(eventDamage/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
