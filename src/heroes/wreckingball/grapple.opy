#!mainFile "../../dev_main.opy"

#!define OW1_WRECKING_BALL_GRAPPLE_COOLDOWN 5

rule "[wreckingball/grapple.opy]: OW1 Grappling Claw Cooldown":
    @Event eachPlayer
    @Hero hammond
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_WRECKING_BALL_GRAPPLE_COOLDOWN)
