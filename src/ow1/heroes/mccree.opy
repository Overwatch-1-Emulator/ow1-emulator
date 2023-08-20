#!mainFile "../../main.opy"

playervar flashbang_origin_position
playervar flashbang_exploded

subroutine initMccree

rule "[mccree.opy]: Set Cassidy hp":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    while (eventPlayer.getMaxHealth() != OW1_MCCREE_HEALTH):
        clearCustomHealth()
        setCustomHealth(OW1_MCCREE_HEALTH, 0, 0)
        wait(1)


rule "[mccree.opy]: Initialize flashbang ability":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    eventPlayer.disallowButton(Button.ABILITY_2)


rule "[mccree.opy]: Throw projectile when pressing e":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.isUsingAbility1() # Ensure Cassidy is not rolling
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Cassidy is not hacked
    @Condition not eventPlayer.hasStatusEffect(Status.FROZEN) # Ensure Cassidy is not frozen
    @Condition not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) # Ensure Cassidy is not knocked down
    @Condition not eventPlayer.hasStatusEffect(Status.ASLEEP) # Ensure Cassidy is not asleep
    @Condition not eventPlayer.hasStatusEffect(Status.STUNNED) # Ensure Cassidy is not stunned

    createProjectile(Projectile.ORB, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), OW1_MCCREE_FLASHBANG_DAMAGE, 1, OW1_MCCREE_FLASHBANG_AOE_RADIUS, DynamicEffect.BAD_EXPLOSION, DynamicEffect.EXPLOSION_SOUND, 0, OW1_MCCREE_FLASHBANG_SPEED, OW1_MCCREE_FLASHBANG_RANGE/OW1_MCCREE_FLASHBANG_SPEED, 0, 0, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_MCCREE_FLASHBANG_COOLDOWN_TIME)


rule "[mccree.opy]: Stun flashed enemy":
    @Event playerTookDamage
    @Condition eventAbility == 0
    @Condition eventDamage >= 15 # This check is needed to ensure that the damage source is flashbang
    @Condition attacker.getCurrentHero() == Hero.MCCREE or attacker.getCurrentHero() == Hero.GENJI

    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_MCCREE_FLASHBANG_STUN_DURATION)


rule "[mccree.opy]: Remove damage reduction during roll":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageReceived(percent(100/(100-OW2_MCCREE_COMBAT_ROLL_DAMAGE_REDUCTION)))
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setDamageReceived(100)


rule "[mccree.opy]: Remove damage reduction during deadeye":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageReceived(percent(100/(100-OW2_MCCREE_DEADEYE_DAMAGE_REDUCTION)))
    waitUntil(not eventPlayer.isUsingUltimate(), 9999)
    eventPlayer.setDamageReceived(100)
