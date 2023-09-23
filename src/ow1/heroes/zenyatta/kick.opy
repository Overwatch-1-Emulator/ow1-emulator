#!mainFile "../../../main.opy"


rule "[zenyatta/kick.opy]: Remove OW2 Snap Kick knockback":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.call_init == true

    eventPlayer.setKnockbackDealt(5)