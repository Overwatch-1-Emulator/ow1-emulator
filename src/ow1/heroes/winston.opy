#!mainFile "../../main.opy"

rule "[winston.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait(1)
    setCustomHealth(OW1_WINSTON_HEALTH, OW1_WINSTON_ARMOR, 0)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START

    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))


rule "[winston.opy]: Set default leap cooldown":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingUltimate()
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_WINSTON_JUMP_PACK_COOLDOWN_TIME)

rule "[winston.opy]: Set leap after ultimate":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.isUsingUltimate() == true

    waitUntil(eventPlayer.isUsingUltimate() == false, Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    