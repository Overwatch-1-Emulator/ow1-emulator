#!mainFile "../../dev_main.opy"

#!define OW1_ROADHOG_SCRAP_SECONDARY_SPEED 80
#!define OW1_ROADHOG_SCRAP_SECONDARY_RANGE 8
# 10 degrees from the axis of the cone
#!define OW1_ROADHOG_SCRAP_CONE_ANGLE 15
#!define OW1_ROADHOG_SCRAP_DAMAGE 250
# Determines how scrap damage scales with distance
# value of 0.5 = 1/x^0.5, 1 = 1/x, 2 = 1/x^2
#!define OW1_ROADHOG_SCRAP_DECAY 1
#!define OW1_ROADHOG_SCRAP_RECOVERY_TIME 1

playervar scrap_gun_pvar
#!defineMember _scrap_detonation_pos scrap_gun_pvar[0]
#!defineMember _detonation_gui scrap_gun_pvar[1]
#!defineMember _scrap_enemies scrap_gun_pvar[2]
#!defineMember _scrap_orientation scrap_gun_pvar[3]
#!defineMember _scrap_last_fire_time scrap_gun_pvar[4]
#!defineMember _scrap_start_pos scrap_gun_pvar[5]
playervar scrap_i


rule "[roadhog/scrap_gun.opy]: OW1 Scrap Gun secondary fire":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition not isCCd(eventPlayer)
    @Condition not eventPlayer.isFiringPrimaryFire()
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition not eventPlayer.isUsingAbility1()
    @Condition not eventPlayer.isUsingAbility2()
    @Condition not eventPlayer._is_using_breather
    @Condition not eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isMeleeing()
    @Condition not eventPlayer.isReloading()
    @Condition eventPlayer.getAmmo(0) > 0
    @Condition getTotalTimeElapsed() - eventPlayer._scrap_last_fire_time > OW1_ROADHOG_SCRAP_RECOVERY_TIME

    eventPlayer._scrap_last_fire_time = getTotalTimeElapsed()
    eventPlayer._scrap_start_pos = eventPlayer.getEyePosition()

    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) - 1)
    eventPlayer._scrap_orientation = eventPlayer.getFacingDirection()
    createProjectile(
        Projectile.ORB, 
        eventPlayer, 
        eventPlayer.getEyePosition(), 
        eventPlayer._scrap_orientation, 
        Relativity.TO_WORLD, 
        ModifyHealth.DAMAGE, 
        getOppositeTeam(eventPlayer.getTeam()), 
        50, 
        1, 
        0, 
        DynamicEffect.GOOD_EXPLOSION, 
        DynamicEffect.EXPLOSION_SOUND, 
        0.001, 
        OW1_ROADHOG_SCRAP_SECONDARY_SPEED, 
        OW1_ROADHOG_SCRAP_SECONDARY_RANGE/OW1_ROADHOG_SCRAP_SECONDARY_SPEED, 
        0, 
        0, 
        0)

    eventPlayer._scrap_detonation_pos = raycast(
        eventPlayer._scrap_start_pos,
        eventPlayer._scrap_start_pos + OW1_ROADHOG_SCRAP_SECONDARY_RANGE * eventPlayer._scrap_orientation,
        getPlayers(getOppositeTeam(eventPlayer.getTeam())),
        null,
        true).getHitPosition()

    # exit if scrap hit enemy before explosion
    if distance(eventPlayer._scrap_start_pos, eventPlayer._scrap_detonation_pos) < OW1_ROADHOG_SCRAP_SECONDARY_RANGE:
        return

    wait(OW1_ROADHOG_SCRAP_SECONDARY_RANGE/OW1_ROADHOG_SCRAP_SECONDARY_SPEED)
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.BLACK, eventPlayer._scrap_detonation_pos, 100)

    eventPlayer._scrap_enemies = [player \
                                  for player \
                                  in eventPlayer.getPlayersInViewAngle(getOppositeTeam(eventPlayer.getTeam()), 90) \
                                  if ((isInLoS(eventPlayer._scrap_detonation_pos, player.getEyePosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) \
                                    or isInLoS(eventPlayer._scrap_detonation_pos, centerMass(player), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) \
                                    or isInLoS(eventPlayer._scrap_detonation_pos, player.getPosition(), BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)) \
                                  and (angleBetweenVectors(eventPlayer._scrap_orientation, directionTowards(eventPlayer._scrap_detonation_pos, (player.getPosition() + player.getEyePosition())/2)) < OW1_ROADHOG_SCRAP_CONE_ANGLE))]

    for eventPlayer.scrap_i in range(len(eventPlayer._scrap_enemies)):
        damage(
            eventPlayer._scrap_enemies[eventPlayer.scrap_i], 
            eventPlayer, 
            min(
                OW1_ROADHOG_SCRAP_DAMAGE, 
                (OW1_ROADHOG_SCRAP_DAMAGE * 2**OW1_ROADHOG_SCRAP_DECAY) 
                / (distance(eventPlayer._scrap_detonation_pos, centerMass(eventPlayer._scrap_enemies[eventPlayer.scrap_i])))**OW1_ROADHOG_SCRAP_DECAY)) # decrease damage quadratically with distance


rule "[roadhog/scrap_gun.opy]: Record last time scrap gun fired":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isFiringPrimaryFire()

    eventPlayer._scrap_last_fire_time = getTotalTimeElapsed()
