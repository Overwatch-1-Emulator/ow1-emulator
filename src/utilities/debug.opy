#!mainFile "../main.opy"

globalvar debug = createWorkshopSetting(bool, "Dev Tools", "debug mode", false)

rule "[debug.opy]: global debug (Top Left)":
    @Event global
    @Condition debug == true

    hudSubheader(getAllPlayers(), "Server Load: {}%".format(getServerLoad()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Average: {}%".format(getAverageServerLoad()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Peak: {}%".format(getPeakServerLoad()), HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "[debug.opy]: player debug (Top Right)":
    @Event eachPlayer
    @Condition debug == true
    
    hudSubheader(eventPlayer, "altitude = {}".format(eventPlayer.getAltitude()), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "hacked = {}".format(eventPlayer.hasStatusEffect(Status.HACKED)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "hero damage dealt = {}".format(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "len(eventPlayer.allowed_heroes) = {}".format(len(eventPlayer.allowed_heroes)), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "len(eventPlayer.getAllowedHeroes()) = {}".format(len(eventPlayer.getAllowedHeroes())), HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)


rule "[debug.opy]: print to console on interact":
    @Event eachPlayer
    @Condition debug == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    for i in range(len(eventPlayer.allowed_heroes)):
        printLog("eventPlayer.allowed_heroes[{}] = {}".format(i, eventPlayer.allowed_heroes[i]))


rule "[debug.opy]: Debug damage instance":
    @Event playerDealtDamage
    @Condition debug == true

    printLog("{} {} {}".format(eventPlayer.getCurrentHero(), eventAbility, eventDamage))
