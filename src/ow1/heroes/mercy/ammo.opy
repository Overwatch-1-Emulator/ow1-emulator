#!mainFile "../../../main.opy"


rule "[mercy/ammo.opy]: Initialize Mercy clip size":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)