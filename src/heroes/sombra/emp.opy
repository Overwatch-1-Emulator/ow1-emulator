#!mainFile "../../main.opy"

playervar emp_pvar
#!defineMember _is_casting_emp emp_pvar[0]


rule "[sombra/emp.opy]: Detect EMP casting":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getUltCharge() >= 100
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    waitUntil(eventPlayer.getUltCharge() == 0, Math.INFINITY)

    eventPlayer._is_casting_emp = true
    wait(OW1_SOMBRA_EMP_CAST_TIME)
    eventPlayer._is_casting_emp = false


rule "[sombra/emp.opy]: Break barrier with EMP":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer._is_casting_emp
    
    eventPlayer.setDamageDealt(100) # Deal 10000 damage to all barrier
    waitUntil(eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(percent(eventPlayer._base_damage_scalar))


rule "[sombra/emp.opy]: Remove OW2 EMP damage":
    @Event playerDealtDamage
    @Hero sombra
    @Condition eventAbility == Button.ULTIMATE

    heal(victim, null, eventDamage)
    damage(victim, attacker, victim.getHealth() - (victim.getHealthOfType(Health.NORMAL) + victim.getHealthOfType(Health.ARMOR)))
