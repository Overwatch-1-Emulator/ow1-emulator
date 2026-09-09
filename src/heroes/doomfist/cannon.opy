#!mainFile "../../main.opy"

rule "[doomfist/cannon.opy]: Deal OW1 hand cannon damage":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_DOOMFIST_HAND_CANNON_DAMAGE/OW2_DOOMFIST_HAND_CANNON_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar) # Deal additional damage to match OW1 damage
    eventPlayer.ow1_true_damage = eventDamage/eventPlayer._base_damage_scalar*(OW1_DOOMFIST_HAND_CANNON_DAMAGE/OW2_DOOMFIST_HAND_CANNON_DAMAGE) - eventDamage
    print(eventDamage + eventPlayer.ow1_true_damage)