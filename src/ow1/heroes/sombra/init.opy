#!mainFile "../../../main.opy"

playervar hack_damage_modifier


rule "[sombra/init.opy]: Initialize Sombra":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.call_init

    resetHero()
    getPlayers(eventPlayer.getTeam()).friendly_sombra_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_sombra_player = eventPlayer
    eventPlayer.call_init = false


rule "[sombra.opy]: Cancel invis if hack activated":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isFiringSecondaryFire()
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "[sombra.opy]: OW1 hack duration on enemies":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    eventPlayer.setStatusEffect(null, Status.HACKED, OW1_SOMBRA_HACK_ENEMY_DURATION)


rule "[sombra.opy]: No damage with EMP":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getUltCharge() >= 100
    
    waitUntil(eventPlayer.isHoldingButton(Button.ULTIMATE) == true, Math.INFINITY)
    waitUntil(eventPlayer.getUltCharge() <= 0, Math.INFINITY)
    eventPlayer.setDamageDealt(0)
    waitUntil(eventPlayer.isUsingUltimate() == true, Math.INFINITY)
    eventPlayer.setDamageDealt(100)


rule "[sombra.opy]: Deal OW1 machine pistol damage":
    @Event playerDealtDamage
    @Hero sombra
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_SOMBRA_MACHINE_PISTOL_DAMAGE/OW2_SOMBRA_MACHINE_PISTOL_DAMAGE)-eventDamage)


rule "[sombra.opy]: Remove hack bonus damage":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    startDamageModification(eventPlayer, eventPlayer.enemy_sombra_player, percent(1/OW2_SOMBRA_HACK_DAMAGE_MULTIPLIER), DamageReeval.NONE)
    eventPlayer.hack_damage_modifier = getLastDamageModification()
    waitUntil(eventPlayer.hasStatusEffect(Status.HACKED) == false, Math.INFINITY)
    stopDamageModification(eventPlayer.hack_damage_modifier)


rule "[sombra.opy]: Increase stealth movement speed":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setMoveSpeed(percent(OW1_SOMBRA_STEALTH_MOVEMENT_BONUS/OW2_SOMBRA_STEALTH_MOVEMENT_BONUS))
    waitUntil(eventPlayer.isUsingAbility1() == false, Math.INFINITY)
    eventPlayer.setMoveSpeed(100)


rule "[sombra.opy]: Set default hack cooldown":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) >= OW2_SOMBRA_HACK_COOLDOWN_TIME
    
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_SOMBRA_HACK_COOLDOWN_TIME)
