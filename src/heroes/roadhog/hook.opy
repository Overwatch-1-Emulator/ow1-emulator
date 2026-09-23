#!mainFile "../../main.opy"

playervar hook_pvar
#!defineMember hook_barrier_hits hook_pvar[1]
#!defineMember hook_connected hook_pvar[2]

rule "[roadhog/hook.opy]: OW1 hook damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ROADHOG_HOOK_DAMAGE/OW2_ROADHOG_HOOK_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)    


rule "[roadhog/hook.opy]: Enemy Orisa barrier blocks hook":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.enemy_orisa_player.barrier_active

    # Where along his aim the hook meets the barrier
    findSphereHit(eventPlayer.getEyePosition(), eventPlayer.getFacingDirection(),
                  eventPlayer.enemy_orisa_player._barrier_origin, OW1_ORISA_PROTECTIVE_BARRIER_RADIUS)
    eventPlayer.hook_barrier_hits = [p for p in eventPlayer._lsi_x if isInsideOrisaBarrier(p,
                  eventPlayer.enemy_orisa_player._barrier_origin, eventPlayer.enemy_orisa_player.barrier_orientation)]
    if len(eventPlayer.hook_barrier_hits) == 0: return
    if distance(eventPlayer.getEyePosition(), eventPlayer.hook_barrier_hits[0]) > OW2_ROADHOG_HOOK_RANGE: return

    # Let the hook fly until it would reach the barrier, unless it grabs someone first
    # or the barrier goes down
    eventPlayer.hook_connected = false
    waitUntil(eventPlayer.hook_connected or not eventPlayer.enemy_orisa_player.barrier_active,
              distance(eventPlayer.getEyePosition(), eventPlayer.hook_barrier_hits[0]) / OW2_ROADHOG_HOOK_PROJECTILE_SPEED)
    if eventPlayer.hook_connected or not eventPlayer.enemy_orisa_player.barrier_active: return

    # Reached the barrier: stop it there
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_ROADHOG_HOOK_COOLDOWN_TIME)
    #playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, eventPlayer.hook_barrier_hits[0], 1)