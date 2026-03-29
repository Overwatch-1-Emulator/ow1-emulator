#!mainFile "../../dev_main.opy"


rule "[winston/leap.opy]: Override leap cooldown during primal":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_WINSTON_PRIMAL_JUMP_PACK_COOLDOWN_TIME)


rule "[winston/leap.opy]: OW1 Winston jump pack damage":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility in [Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_WINSTON_JUMP_PACK_DAMAGE/OW2_WINSTON_JUMP_PACK_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
