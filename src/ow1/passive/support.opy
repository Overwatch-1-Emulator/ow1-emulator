#!mainFile "../../main.opy"

rule "Disable support self-healing passive":
    @Event playerReceivedHealing
    # apply to only support heroes
    @Condition eventPlayer.getCurrentHero() in getSupportHeroes()
    # apply to self healing (event player heals themselves)
    @Condition healer == eventPlayer
    @Condition healee == eventPlayer
    # apply to passive healing (healing ability source = non-existent)
    @Condition eventAbility == 0
    
    printLog("{}".format(eventHealing))
    if (eventPlayer.getCurrentHero() not in [Hero.MERCY, Hero.BAPTISTE, Hero.ZENYATTA, Hero.BRIGITTE]):
        damage(eventPlayer, null, eventHealing)
