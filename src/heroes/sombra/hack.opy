#!mainFile "../../main.opy"


rule "[sombra/hack.opy]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    eventPlayer.setStatusEffect(eventPlayer.enemy_sombra_player, Status.HACKED, OW1_SOMBRA_HACK_ENEMY_DURATION)
