#!mainFile "../../../main.opy"


rule "[zenyatta/ammo.opy]: Initialize OW1 Zenyatta ammo":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.call_init == true

    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)