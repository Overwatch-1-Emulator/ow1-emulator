#!mainFile "../../dev_main.opy"


rule "[mccree/flashbang.opy]: Throw projectile when pressing e":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0
    @Condition not eventPlayer.isUsingAbility1() # Ensure Cassidy is not rolling
    @Condition not isCCd(eventPlayer)

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
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_MCCREE_FLASHBANG_COOLDOWN)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.YELLOW, eventPlayer, 100)


rule "[mccree/flashbang.opy]: Stun flashed enemy":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventAbility == 0

    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_MCCREE_FLASHBANG_STUN_DURATION)
