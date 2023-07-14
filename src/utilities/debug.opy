#!mainFile "../main.opy"

rule "[debug.opy]: Display server performance characteristics":
    @Disabled
    hudHeader(getAllPlayers(), l"{0}: {1}".format(l"Server Load", l"{0}%".format(getServerLoad())), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(getAllPlayers(), l"{0}: {1}".format(l"Server Load Average", l"{0}%".format(getAverageServerLoad())), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudHeader(getAllPlayers(), l"{0}: {1}".format(l"Server Load Peak", l"{0}%".format(getPeakServerLoad())), HudPosition.LEFT, 2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "[debug.opy]: Debug HUD text":
    @Disabled
    @Event eachPlayer
    
    hudSubheader(eventPlayer, "{}".format(eventPlayer.getAltitude()), HudPosition.TOP, 0, Color.WHITE, HudReeval.STRING)


rule "[debug.opy]: Debug damage instance":
    @Disabled
    @Event playerDealtDamage

    printLog("{} {} {}".format(eventPlayer.getCurrentHero(), eventAbility, eventDamage))