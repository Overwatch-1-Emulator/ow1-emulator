#!mainFile "../../dev_main.opy"

rule "[mccree/flashbang.opy]: Flashbang ooldown":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.isUsingAbility2()

    waitUntil(updateEveryTick(not eventPlayer.isUsingAbility2()), Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_MCCREE_FLASHBANG_COOLDOWN)


rule "[mccree/flashbang.opy]: Stun flashed enemy":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventAbility == Button.ABILITY_2

    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_MCCREE_FLASHBANG_STUN_DURATION)
