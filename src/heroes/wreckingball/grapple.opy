#!mainFile "../../dev_main.opy"


rule "[wreckingball/grapple.opy]: OW1 Fireball Damage":
    @Event playerDealtDamage
    @Hero hammond
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, ((60/50)*(eventDamage/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
