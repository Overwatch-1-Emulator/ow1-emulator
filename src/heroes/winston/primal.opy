#!mainFile "../../dev_main.opy"

playervar primal_pvar
#!defineMember _primal_exit_health primal_pvar[0]
#!defineMember _primal_exit_armor primal_pvar[1]


rule "[winston/primal.opy]: Fix primal rage hp":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    
    setCustomHp(OW1_WINSTON_PRIMAL_HEALTH, OW1_WINSTON_PRIMAL_ARMOR, 0)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    # Recreate primal exit hp logic
    eventPlayer._primal_exit_health = eventPlayer.getHealthOfType(Health.NORMAL)
    eventPlayer._primal_exit_armor = eventPlayer.getHealthOfType(Health.ARMOR)
    setCustomHp(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)
    eventPlayer.setHealth(min(OW1_WINSTON_HEALTH, eventPlayer._primal_exit_health) + eventPlayer._primal_exit_armor)


rule "[winston/primal.opy]: Increase knockback during primal":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setKnockbackDealt(140)
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setKnockbackDealt(100)


rule "[winston/primal.opy]: Increase knockback damage during primal":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility == Button.ULTIMATE

    damage(victim, attacker, ((OW1_WINSTON_PRIMAL_DAMAGE/OW2_WINSTON_PRIMAL_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar) - eventDamage)/eventPlayer._base_damage_scalar)
