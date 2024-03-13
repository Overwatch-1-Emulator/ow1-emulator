#!mainFile "../../main.opy"


rule "[symmetra/init.opy]: Correct Photon Projector damage":
    @Event playerDealtDamage
    @Hero symmetra
    @Condition eventAbility == Button.ABILITY_1

    damage(
        victim, 
        attacker, 
        ((OW1_SYMMETRA_PROJECTOR_DAMAGE/OW2_SYMMETRA_PROJECTOR_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)
