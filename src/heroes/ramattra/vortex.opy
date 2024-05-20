#!mainFile "../../dev_main.opy"


rule "[ramattra/vortex.opy]: Correct Ravenous Vortex damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.RAMATTRA
    @Condition eventAbility == Button.ABILITY_2
    
    heal(victim, null, eventDamage - (OW1_RAMATTRA_VORTEX_DAMAGE/OW2_RAMATTRA_VORTEX_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))
