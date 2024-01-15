#!mainFile "../../main.opy"


rule "[winston/init.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Hero winston

    eventPlayer.call_init = true


rule "[winston/init.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.call_init

    newHero(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)
    setUltCost(OW1_WINSTON_ULT_COST)

    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))

    removeTankPassive()
    eventPlayer.call_init = false


rule "[winston.opy]: Override leap cooldown during primal":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_WINSTON_PRIMAL_JUMP_PACK_COOLDOWN_TIME)
