#!mainFile "../../main.opy"

rule "[roadhog/hook.opy]: OW1 hook damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ROADHOG_HOOK_DAMAGE_VS_ARMOR/OW2_ROADHOG_HOOK_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)    
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ROADHOG_HOOK_DAMAGE/OW2_ROADHOG_HOOK_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)    
