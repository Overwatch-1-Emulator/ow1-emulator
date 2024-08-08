#!mainFile "../dev_main.opy"

globalvar reset_gvar
#!defineMember ready_color reset_gvar[0]

playervar reset_pvar
#!defineMember _reset_complete reset_pvar[0]
#!defineMember friendly_orisa_player reset_pvar[2]
#!defineMember friendly_sombra_player reset_pvar[3]
#!defineMember enemy_orisa_player reset_pvar[5]
#!defineMember enemy_sombra_player reset_pvar[6]
#!defineMember _hero_setup reset_pvar[7]
#!defineMember _hp_reset reset_pvar[8]
#!defineMember _stat_reset reset_pvar[9]
#!defineMember _status_reset reset_pvar[10]
#!defineMember _frenemy_reset reset_pvar[11]
#!defineMember _ult_charge_reset reset_pvar[12]
#!defineMember _self_healing_reset reset_pvar[13]
#!defineMember _ability_reset reset_pvar[14]

subroutine clearCustomHp
subroutine enableAllAbilities
subroutine disableAllAbilities
subroutine resetStats
subroutine resetStatuses
subroutine resetFrenemies
subroutine resetUltCharge
subroutine resetSelfHealing

#!define isResetComplete(player)\
    (player._hp_reset \
 and player._stat_reset \
 and player._status_reset \
 and player._frenemy_reset \
 and player._ult_charge_reset \
 and player._self_healing_reset \
 and player._ability_reset)

def resetHero():
    @Name "[utilities/reset.opy]: resetHero()"

    async(clearCustomHp, AsyncBehavior.RESTART)
    async(resetStats, AsyncBehavior.RESTART)
    async(resetStatuses, AsyncBehavior.RESTART)
    async(resetFrenemies, AsyncBehavior.RESTART)
    async(resetUltCharge, AsyncBehavior.RESTART)
    async(resetSelfHealing, AsyncBehavior.RESTART)
    async(enableAllAbilities, AsyncBehavior.RESTART)

    wait() # wait at least 1 tick
    waitUntil(updateEveryTick(isResetComplete(eventPlayer)), Math.INFINITY)


def enableAllAbilities():
    @Name "[utilities/reset.opy]: enableAllAbilities()"

    eventPlayer._ability_reset = false

    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)

    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.INTERACT)

    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setUltEnabled(true)

    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setJumpEnabled(true)
    eventPlayer.setCrouchEnabled(true)
    eventPlayer.setReloadEnabled(true)

    eventPlayer._ability_reset = true


def disableAllAbilities():
    @Name "[utilities/reset.opy]: disableAllAbilities()"

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)

    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.disallowButton(Button.INTERACT)

    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setUltEnabled(false)

    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setJumpEnabled(false)
    eventPlayer.setCrouchEnabled(false)
    eventPlayer.setReloadEnabled(false)


def resetStats():
    @Name "[utilities/reset.opy]: resetStats()"

    eventPlayer._stat_reset = false

    setBaseDamage(eventPlayer, 1)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    setBaseHealing(eventPlayer, 1)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)
    eventPlayer.setGravity(100)
    setBaseMovement(eventPlayer, 1)

    eventPlayer._stat_reset = true


def resetStatuses():
    @Name "[utilities/reset.opy]: resetStatuses()"

    eventPlayer._status_reset = false

    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.clearStatusEffect(Status.FROZEN)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.STUNNED)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)

    eventPlayer._status_reset = true


def resetFrenemies():
    @Name "[utilities/reset.opy]: resetFrenemies()"

    eventPlayer._frenemy_reset = false

    eventPlayer.friendly_orisa_player = getPlayersOnHero(Hero.ORISA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_orisa_player = getPlayersOnHero(Hero.ORISA, getOppositeTeam(eventPlayer.getTeam()))[0]
    eventPlayer.friendly_sombra_player = getPlayersOnHero(Hero.SOMBRA, eventPlayer.getTeam())[0]
    eventPlayer.enemy_sombra_player = getPlayersOnHero(Hero.SOMBRA, getOppositeTeam(eventPlayer.getTeam()))[0]

    eventPlayer._frenemy_reset = true


rule "[utilities/reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds()

    waitUntil(not isMatchBetweenRounds(), Math.INFINITY)
    wait(1)
    resetHero()
    initHero()
    printLog('called init after new round')
