#!mainFile "../../main.opy"

playervar flashbang_origin_position
playervar flashbang_exploded

def initMccree():

    do:
        clearCustomHealth()
        setCustomHealth(OW1_MCCREE_HEALTH, 0, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_MCCREE_HEALTH)

    eventPlayer.disallowButton(Button.ABILITY_2)

rule "[mccree.opy]: Initialize Mccree":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initMccree()
    eventPlayer.initialized = true

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
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_MCCREE_FLASHBANG_COOLDOWN)

rule "[mccree.opy]: Stun flashed enemy":
    @Event playerTookDamage
    @Condition eventAbility == 0
    @Condition attacker.getCurrentHero() == Hero.MCCREE or attacker.getCurrentHero() == Hero.GENJI

    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_MCCREE_FLASHBANG_STUN_DURATION)
