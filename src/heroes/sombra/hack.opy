#!mainFile "../../dev_main.opy"

playervar hack_timer

#!define isHacked(player) (player.hack_timer > 0)


rule "[sombra/hack.opy]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(eventPlayer.enemy_sombra_player, Status.HACKED, OW1_SOMBRA_HACK_ENEMY_DURATION)
    eventPlayer.hack_timer = OW1_SOMBRA_HACK_ENEMY_DURATION
    chase(eventPlayer.hack_timer, 0, rate=1, ChaseReeval.NONE)

rule "[sombra/hack.opy]: Reset hack if has stealth passive":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isFiringSecondaryFire()

    wait(OW2_SOMBRA_HACK_CAST_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    damage(eventPlayer, null, 0.01)
    heal(eventPlayer, null, 0.01)
    if RULE_CONDITION:
        goto RULE_START
