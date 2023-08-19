#!mainFile "../main.opy"

globalvar debug = createWorkshopSetting(bool, "Dev Tools", "debug mode", false)

rule "[debug.opy]: global debug (Top Left)":
    @Event global
    @Condition debug == true

    hudHeader(getAllPlayers(), "Global", HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load: {}%".format(getServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Average: {}%".format(getAverageServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(getAllPlayers(), "Server Load Peak: {}%".format(getPeakServerLoad()), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "[debug.opy]: player debug (Top Right)":
    @Event eachPlayer
    @Condition debug == true

    hudHeader(eventPlayer, "Event Player", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getAltitude() = {}".format(eventPlayer.getAltitude()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "hasStatusEffect(Status.HACKED) = {}".format(eventPlayer.hasStatusEffect(Status.HACKED)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getStatistic(Stat.HERO_DAMAGE_DEALT) = {}".format(eventPlayer.getStatistic(Stat.HERO_DAMAGE_DEALT)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "len(allowed_heroes) = {}".format(len(eventPlayer.allowed_heroes)), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "len(getAllowedHeroes()) = {}".format(len(eventPlayer.getAllowedHeroes())), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isUsingUltimate() = {}".format(eventPlayer.isUsingUltimate()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getUltCharge() = {}".format(eventPlayer.getUltCharge()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getUltCharge() >= 100 = {}".format(eventPlayer.getUltCharge() >= 100), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isFiringPrimaryFire() = {}".format(eventPlayer.isFiringPrimaryFire()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isFiringSecondaryFire() = {}".format(eventPlayer.isFiringSecondaryFire()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isUsingAbility1() = {}".format(eventPlayer.isUsingAbility1()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "isUsingAbility2() = {}".format(eventPlayer.isUsingAbility2()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getSpeed() = {}".format(eventPlayer.getSpeed()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "ult_cost[hero_id] = {}".format(ult_cost[eventPlayer.hero_id]), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "ult_percent_compensated = {}".format(eventPlayer.ult_percent_compensated), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "call_reset = {}".format(eventPlayer.call_reset), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "call_initialize = {}".format(eventPlayer.call_initialize), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)
    hudSubheader(eventPlayer, "getMaxHealth() = {}".format(eventPlayer.getMaxHealth()), HudPosition.RIGHT, 1, Color.WHITE, HudReeval.STRING)


rule "[debug.opy]: print to console on interact":
    @Event eachPlayer
    @Condition debug == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    for i in range(len(eventPlayer.allowed_heroes)):
        printLog("eventPlayer.allowed_heroes[{}] = {}".format(i, eventPlayer.allowed_heroes[i]))


rule "[debug.opy]: Debug damage instance":
    @Event playerDealtDamage
    @Condition debug == true

    printLog("hero={}, ability={}, amount={}".format(eventPlayer.getCurrentHero(), eventAbility, eventDamage))


rule "[debug.opy]: Debug healing instance":
    @Event playerDealtHealing
    @Condition debug == true

    printLog("hero={}, ability={}, amount={}".format(eventPlayer.getCurrentHero(), eventAbility, eventHealing))
