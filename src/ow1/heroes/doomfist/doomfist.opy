#!mainFile "../../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_using_slam

#!include "ow1/heroes/doomfist/hp.opy"
#!include "ow1/heroes/doomfist/uppercut.opy"
#!include "ow1/heroes/doomfist/slam.opy"
#!include "ow1/heroes/doomfist/punch.opy"
#!include "ow1/heroes/doomfist/meteor.opy"
#!include "ow1/heroes/doomfist/cannon.opy"

rule "[doomfist.opy]: Initialize Doomfist":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.call_initialize == true

    getPlayers(eventPlayer.getTeam()).friendly_doomfist_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_doomfist_player = eventPlayer
