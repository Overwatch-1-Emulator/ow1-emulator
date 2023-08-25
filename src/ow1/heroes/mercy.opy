#!mainFile "../../main.opy"

rule "[mercy.opy]: Initialize Mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)


rule "[mercy.opy]: Change GA Cooldown":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingAbility1() == true and eventPlayer.isHoldingButton(Button.JUMP) == true or eventPlayer.isUsingAbility1() == true and eventPlayer.isHoldingButton(Button.CROUCH) == true and eventPlayer.isUsingUltimate() == false

    waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
