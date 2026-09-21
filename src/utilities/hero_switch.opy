#!mainFile "../main.opy"

playervar hero_switch_pvar
#!defineMember _last_hero_played hero_switch_pvar[0]
#!defineMember _hero_switched hero_switch_pvar[1]
#!defineMember _hero_id hero_switch_pvar[2]

macro switchedHero(player):
    player._hero_switched


rule "[utilities/hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer._last_hero_played != eventPlayer.getCurrentHero()

    eventPlayer._hero_switched = true
    wait()
    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._hero_id = heroID(eventPlayer._last_hero_played)
    eventPlayer._hero_switched = false


rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition switchedHero(eventPlayer)

    waitUntil(eventPlayer.hasSpawned(), Math.INFINITY)
    waitUntil(not switchedHero(eventPlayer), Math.INFINITY)
    wait(eventPlayer.getSlot() * TICK_DURATION) # spread reset+init across ticks instead of all 12 at once
    eventPlayer._hero_setup = eventPlayer.getCurrentHero()
    resetHero()
    initHero()

    # A swap during reset/init (resetUltCharge alone can wait up to 1s) can't
    # re-trigger this rule while it's still running, so that hero would never be
    # initialized. Re-run for the hero the player actually ended up on. This also
    # coalesces rapid swaps into one reset cycle instead of restarting the reset
    # subroutines on every swap.
    if eventPlayer.getCurrentHero() != eventPlayer._hero_setup and not eventPlayer.isDuplicatingAHero():
        goto RULE_START
