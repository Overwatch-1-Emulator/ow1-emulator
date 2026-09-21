#!mainFile "../../main.opy"

playervar inspire_pvar
#!defineMember list_of_players inspire_pvar[0]
#!defineMember inspire_allies  inspire_pvar[1]

rule "[brigitte/inspire.opy]: Inspire self healing logic":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition not eventPlayer.isFiringSecondaryFire()
    @Condition eventAbility in [Button.ABILITY_1, Button.PRIMARY_FIRE]

    eventPlayer.list_of_players = getRealPlayersInRadius(eventPlayer.getPosition(), OW1_BRIGITTE_INSPIRE_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES)
    # Per ally, so each one's previous Inspire heal is stopped and refreshed instead of
    # stacking: getLastHealingOverTimeId() only returns ONE id, so the old array-wide
    # version stopped just one ally's heal-over-time and the rest kept stacking.
    # rally_i is reused as the index: this loop has no waits, so it can't interleave with Rally's.
    for eventPlayer.rally_i in range(len(eventPlayer.list_of_players)):
        stopHealingOverTime(eventPlayer.list_of_players[eventPlayer.rally_i].inspire_allies)
        eventPlayer.list_of_players[eventPlayer.rally_i].startHealingOverTime(eventPlayer, OW1_BRIGITTE_INSPIRE_DURATION, OW1_BRIGITTE_INSPIRE_HEALING) # Compensate to get 90 healing
        eventPlayer.list_of_players[eventPlayer.rally_i].inspire_allies = getLastHealingOverTimeId()
    wait(OW1_BRIGITTE_INSPIRE_COOLDOWN) # There is a 1 second cooldown before inspire can be triggered again
    


