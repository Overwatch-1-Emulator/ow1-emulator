#!mainFile "../../main.opy"

playervar list_of_players
playervar inspire_damage

rule "[brigitte/inspire.opy]: Inspire self healing logic for 6 seconds in 4":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.inspire_damage == 1

    eventPlayer.list_of_players = getRealPlayersInRadius(eventPlayer.getPosition(), 20, eventPlayer.getTeam(), LosCheck.SURFACES)
    stopHealingOverTime(eventPlayer.list_of_players.A)
    eventPlayer.list_of_players.startHealingOverTime(eventPlayer, 4, 7.5)
    eventPlayer.list_of_players.A = getLastHealingOverTimeId()
    wait(4)
    eventPlayer.inspire_damage = 0


rule "brigitt/init.opy: Inspire Trigger":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition not eventPlayer.isFiringSecondaryFire() and eventAbility == Button.PRIMARY_FIRE

    eventPlayer.inspire_damage = 1
