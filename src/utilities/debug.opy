#!mainFile "../main.opy"

globalvar debug = createWorkshopSetting(bool, "Dev Tools", "debug mode", false)

rule "[debug.opy]: global debug (Top Left)":
    @Condition debug == true

    hudSubheader(getAllPlayers(), "Server Load: {}%".format(getServerLoad()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Average: {}%".format(getAverageServerLoad()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Peak: {}%".format(getPeakServerLoad()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "[debug.opy]: player debug (Top Right)":
    @Event eachPlayer
    @Condition debug == true
    
    hudSubheader(eventPlayer, "altitude: {}".format(eventPlayer.getAltitude()), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Hacked?: {}".format(eventPlayer.hasStatusEffect(Status.HACKED)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "Hero Damage Dealt: {}".format(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)


rule "[debug.opy]: Debug damage instance":
    @Event playerDealtDamage
    @Condition debug == true

    printLog("{} {} {}".format(eventPlayer.getCurrentHero(), eventAbility, eventDamage))
