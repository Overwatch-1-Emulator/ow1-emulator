#!mainFile "../../main.opy"

playervar global_passive_pvar
#!defineMember _heal_reduction_expiry global_passive_pvar[0]


# Tracked per victim: the event rule only stamps an expiry (no waits), so
# overlapping hits from any number of attackers just extend one timer.
rule "[passives/global/global_passive.opy]: Track DPS passive on victim":
    @Event playerTookDamage
    @Condition attacker != eventPlayer
    @Condition attacker.isAlive()

    eventPlayer._heal_reduction_expiry = getTotalTimeElapsed() + OW2_DAMAGE_PASSIVE_DURATION


rule "[passives/global/global_passive.opy]: Remove DPS passive (Dealing damage reduces enemy healing received)":
    @Event eachPlayer
    @Condition eventPlayer._heal_reduction_expiry > getTotalTimeElapsed()

    eventPlayer.setHealingReceived(percent(100/(100-(OW2_DAMAGE_PASSIVE_HEAL_REDUCTION_PERCENT if eventPlayer.role != Role.TANK else OW2_DAMAGE_PASSIVE_TANK_HEAL_REDUCTION_PERCENT))))
    # Re-reads the expiry every tick, so new hits extend the window
    waitUntil(getTotalTimeElapsed() >= eventPlayer._heal_reduction_expiry, Math.INFINITY)
    eventPlayer.setHealingReceived(100)
