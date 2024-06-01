#!mainFile "../../dev_main.opy"

playervar flashbang_pvar
#!defineMember _is_using_flashbang flashbang_pvar[0]


rule "[mccree/flashbang.opy]: Flashbang VFX":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.isUsingAbility1() # Ensure Cassidy is not rolling
    @Condition not isCCd(eventPlayer)

    eventPlayer._is_using_flashbang = true
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)

    createProjectile(Projectile.ORB, 
                     eventPlayer, 
                     null, 
                     null, 
                     Relativity.TO_WORLD, 
                     ModifyHealth.DAMAGE, 
                     getOppositeTeam(eventPlayer.getTeam()), 
                     OW1_MCCREE_FLASHBANG_DAMAGE, 
                     1, 
                     OW1_MCCREE_FLASHBANG_AOE_RADIUS, 
                     DynamicEffect.BAD_EXPLOSION, 
                     DynamicEffect.EXPLOSION_SOUND, 
                     0, 
                     OW1_MCCREE_FLASHBANG_SPEED, 
                     OW1_MCCREE_FLASHBANG_RANGE/OW1_MCCREE_FLASHBANG_SPEED, 
                     0, 
                     0, 
                     1)

    wait(OW1_MCCREE_FLASHBANG_RANGE/OW1_MCCREE_FLASHBANG_SPEED)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 100)
    wait(10 * TICK_DURATION)
    eventPlayer._is_using_flashbang = false


rule "[mccree/flashbang.opy]: Flashbang recovery and cooldown":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer._is_using_flashbang

    wait(OW1_MCCREE_FLASHBANG_RECOVERY_TIME)
    eventPlayer.setPrimaryFireEnabled(true)
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE): eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setSecondaryFireEnabled(true)
    if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE): eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)

    wait(OW1_MCCREE_FLASHBANG_USAGE_DURATION - OW1_MCCREE_FLASHBANG_RECOVERY_TIME)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_MCCREE_FLASHBANG_COOLDOWN)


rule "[mccree/flashbang.opy]: Stun flashed enemy":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventAbility == 0
    @Condition eventPlayer._is_using_flashbang

    eventPlayer._is_using_flashbang = false
    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_MCCREE_FLASHBANG_STUN_DURATION)
