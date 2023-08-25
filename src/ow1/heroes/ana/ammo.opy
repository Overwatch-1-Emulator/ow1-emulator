#!mainFile "../../../main.opy"

rule "[ana/ammo.opy]: Initialize Ana clip size":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.call_init == true

    eventPlayer.setAmmo(0, OW1_ANA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ANA_CLIP_SIZE)
