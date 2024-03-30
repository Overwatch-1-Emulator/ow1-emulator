#!mainFile "../../dev_main.opy"


rule "[genji/deflect.opy]: Reset deflect cooldown on elim":
    @Event playerEarnedElimination
    @Hero genji

    if eventPlayer.isUsingAbility2():
        waitUntil(not eventPlayer.isUsingAbility2() and eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, Math.INFINITY)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
