#!mainFile "../../main.opy"

playervar inspire_pvar
#!defineMember list_of_players inspire_pvar[0]
#!defineMember inspire_damage  inspire_pvar[1]
#!defineMember inspire_allies  inspire_pvar[2]

rule "[brigitte/inspire.opy]: Inspire self healing logic":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.inspire_damage

    eventPlayer.list_of_players = getRealPlayersInRadius(eventPlayer.getPosition(), OW1_BRIGITTE_INSPIRE_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES)
    stopHealingOverTime(eventPlayer.list_of_players.inspire_allies)
    eventPlayer.list_of_players.startHealingOverTime(eventPlayer, OW2_BRIGITTE_INSPIRE_DURATION, (OW1_BRIGITTE_INSPIRE_HEALING/2)) # Compensate to get 90 healing
    eventPlayer.list_of_players.inspire_allies = getLastHealingOverTimeId()
    wait(OW2_BRIGITTE_INSPIRE_DURATION)
    eventPlayer.inspire_damage = false


rule "[brigitte/inspire.opy]: Trigger custom Inspire":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition not eventPlayer.isFiringSecondaryFire() and eventAbility == Button.PRIMARY_FIRE

    eventPlayer.inspire_damage = true
    