#!mainFile "../../main.opy"

rule "[roadhog/hook.opy]: OW1 hook damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ROADHOG_HOOK_DAMAGE/OW2_ROADHOG_HOOK_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)    
    eventPlayer.ow1_true_damage = eventDamage/eventPlayer._base_damage_scalar*(OW1_ROADHOG_HOOK_DAMAGE/OW2_ROADHOG_HOOK_DAMAGE) - eventDamage
    print(eventDamage+eventPlayer.ow1_true_damage)