#!mainFile "../../dev_main.opy"


rule "[genji/deflect.opy]: Reset deflect cooldown on elim":
    @Event playerEarnedElimination
    @Hero genji

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
