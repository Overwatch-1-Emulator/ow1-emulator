#!mainFile "../../main.opy"

playervar sombra_pvar
#!defineMember hack_damage_modifier sombra_pvar[0]
#!defineMember stealth_hud_id sombra_pvar[1]
#!defineMember is_using_stealth sombra_pvar[2]


# Also removes OW2 hack's bonus damage (was a separate rule in stealth.opy with the
# exact same condition; merged so the condition is only checked once per player)
rule "[sombra/hack.opy]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    eventPlayer.setStatusEffect(eventPlayer.enemy_sombra_player, Status.HACKED, OW1_SOMBRA_HACK_ENEMY_DURATION)
    eventPlayer.hack_end_time = getTotalTimeElapsed() + OW1_SOMBRA_HACK_ENEMY_DURATION

    # Remove OW2 hack bonus damage for as long as the hack lasts
    startDamageModification(eventPlayer, eventPlayer.enemy_sombra_player, percent(1/OW2_SOMBRA_HACK_DAMAGE_MULTIPLIER), DamageReeval.NONE)
    eventPlayer.hack_damage_modifier = getLastDamageModification()
    waitUntil(eventPlayer.hasStatusEffect(Status.HACKED) == false, Math.INFINITY)
    stopDamageModification(eventPlayer.hack_damage_modifier)



rule "[sombra/hack.opy]: Cancel hack when interupted":
    @Event playerTookDamage
    @Hero sombra
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setStatusEffect(null, Status.STUNNED, TICK_DURATION) # Play damage cancel Hack animation + cancel hack itself
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_SOMBRA_HACK_INTERRUPTION_COOLDOWN)