#!mainFile "../../../main.opy"


rule "[baptiste/ammo.opy]: Initialize OW1 Baptiste ammo":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.call_init == true

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)