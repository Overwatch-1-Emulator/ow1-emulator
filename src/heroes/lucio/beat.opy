#!mainFile "../../dev_main.opy"

playervar beat_pvar
#!defineMember _beat_enemies beat_pvar[0]
#!defineMember _beat_dropped beat_pvar[1]


rule "[lucio/beat.opy]: Deal damage with Sound Barrier":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getAltitude() > 0
    @Condition not eventPlayer._beat_dropped

    waitUntil(eventPlayer.getAltitude() <= 0, Math.INFINITY)
    eventPlayer._beat_dropped = true

    eventPlayer._beat_enemies = getPlayersInRadius(eventPlayer, 3, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)
    eventPlayer._beat_enemies = [player for player in eventPlayer._beat_enemies if (angleBetweenVectors(Vector.DOWN, directionTowards(eventPlayer.getEyePosition(), player.getEyePosition())) < 45)]
    damage(eventPlayer._beat_enemies, eventPlayer, 1000000)

    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer._beat_dropped = false
