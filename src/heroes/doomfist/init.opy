#!mainFile "../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_ultimate_locked


#!include "uppercut.opy"
#!include "slam.opy"
#!include "punch.opy"
#!include "meteor.opy"
#!include "cannon.opy"
#!include "defense.opy"


def initDoomfist():
    @Name "[doomfist/init.opy]: initDoomfist()"

    eventPlayer.setMaxHealth(percent(0.1/OW2_DOOMFIST_BEST_DEFENSE))
    eventPlayer._hp_scalar = percent(0.1/OW2_DOOMFIST_BEST_DEFENSE)
    setUltCost(OW1_DOOMFIST_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)
    if eventPlayer.getHealth() < 5:
        eventPlayer.addHealthPool(Health.NORMAL, 246, true, true)
    initRocketPunch()
    initSlam()
    eventPlayer.best_defense_shields = 0
    #eventPlayer.uppercut_shields = 0


rule "[doomfist/init.opy]: Clean up Doomfist":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.DOOMFIST

    waitUntil(eventPlayer.getCurrentHero() != Hero.DOOMFIST, Math.INFINITY)
    destroySlamIndicatorGui()
    hideSlamDamageGui()


rule "[doomfist/init.opy]: Compensate Global Damage Reduction":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility in [Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
