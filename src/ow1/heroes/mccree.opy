#!mainFile "../../main.opy"

playervar flashbang_origin_position
playervar flashbang_exploded

def initMccree():
    eventPlayer.setAbility2Enabled(false)

rule "[mccree.opy]: Initialize Mccree":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initMccree()

rule "[mccree.opy]: Throw projectile when pressing e":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.isUsingAbility1() # Ensure Cassidy is not rolling
    @Condition not eventPlayer.hasStatusEffect(Status.HACKED) # Ensure Cassidy is not hacked

    createProjectile(Projectile.PHARAH_ROCKET, eventPlayer, null, null, Relativity.TO_WORLD, ModifyHealth.DAMAGE, getOppositeTeam(eventPlayer.getTeam()), 25, 1, 3, DynamicEffect.BAD_EXPLOSION, DynamicEffect.MCCREE_FLASHBANG_EXPLOSION_SOUND, 0, 30, 0.233, 0, 0, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_MCCREE_FLASHBANG_COOLDOWN)

rule "[mccree.opy]: Stun flashed enemy":
    @Event playerTookDamage
    @Condition eventAbility == 0
    @Condition attacker.getCurrentHero() == Hero.MCCREE or attacker.getCurrentHero() == Hero.GENJI

    victim.setStatusEffect(eventPlayer, Status.STUNNED, ow1_flashbang_stun_duration)