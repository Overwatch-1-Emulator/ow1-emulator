#!mainFile "../../dev_main.opy"

playervar list_of_players
rule "[brigitte/inspire.opy]: Inspire self healing logic":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.B == 1

    eventPlayer.list_of_players = getRealPlayersInRadius(eventPlayer.getPosition(), 20, eventPlayer.getTeam(), LosCheck.SURFACES)
    stopHealingOverTime(eventPlayer.list_of_players.A)
    eventPlayer.list_of_players.startHealingOverTime(eventPlayer, 6, 15)
    eventPlayer.list_of_players.A = getLastHealingOverTimeId()
    wait(1)
    eventPlayer.B = 0
    

    #pushSelfHealing(Button.MELEE)
    #wait(OW1_BRIGITTE_INSPIRE_DURATION, Wait.RESTART_WHEN_TRUE)
    #popSelfHealing(Button.MELEE)
    
rule "brigitt/init.opy: balh":
    @Event playerDealtDamage
    @Hero brigitte
    
    if eventPlayer.B == 1:
        waitUntil(getLastHealingOverTimeId() == 0)
        eventPlayer.B = 1
    else:
        eventPlayer.B = 1


