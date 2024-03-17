#!mainFile "../../dev_main.opy"


rule "[ramattra/vortex.opy]: Correct Ravenous Vortex damage":
    @Event playerDealtDamage
    @Hero ramattra
    @Condition eventAbility == Button.ABILITY_2
    
    heal(victim, null, eventDamage - (OW1_RAMATTRA_VORTEX_DAMAGE/OW2_RAMATTRA_VORTEX_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))
