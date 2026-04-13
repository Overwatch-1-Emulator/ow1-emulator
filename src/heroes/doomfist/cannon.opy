#!mainFile "../../main.opy"

rule "[doomfist/cannon.opy]: Deal OW1 hand cannon damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_DOOMFIST_HAND_CANNON_DAMAGE_VS_ARMOR/OW2_DOOMFIST_HAND_CANNON_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar) # Deal additional damage to match OW1 damage
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_DOOMFIST_HAND_CANNON_DAMAGE/OW2_DOOMFIST_HAND_CANNON_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar) # Deal additional damage to match OW1 damage
