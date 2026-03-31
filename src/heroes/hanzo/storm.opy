#!mainFile "../../main.opy"


rule "[hanzo/storm.opy]: OW1 storm arrow damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_HANZO_STORM_ARROW_DAMAGE/OW2_HANZO_STORM_ARROW_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)    
