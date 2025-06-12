#!mainFile "../dev_main.opy"

playervar perk_i
playervar perk_pvar
#!defineMember perk_enemy_ perk_pvar[0]
#!defineMember perk_hp_backup_ perk_pvar[1]
#!defineMember perk_ult_charge_backup_ perk_pvar[2]
#!defineMember perk_enemies_ perk_pvar[3]
#!defineMember perk_points_ perk_pvar[4]
#!defineMember max_perk_points_ perk_pvar[5]

subroutine unlockAllPerks

def resetPerkCost():
    eventPlayer.max_perk_points_ = 0
    eventPlayer.perk_points_ = 0
    eventPlayer.perk_ult_charge_backup_ = 0


macro setPerkCost(required_perk_points):
    eventPlayer.max_perk_points_ = required_perk_points


def unlockAllPerks():
    @Name "[orisa/init.opy]: unlockAllPerks()"
    eventPlayer.perk_ult_charge_backup_ = eventPlayer.getUltCharge()
    wait()

    while (eventPlayer.perk_points_ < eventPlayer.max_perk_points_):
        # get enemies not in spawn room
        eventPlayer.perk_enemies_ = [enemy for enemy in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if not enemy.isInSpawnRoom()]
        if (len(eventPlayer.perk_enemies_) == 0):
            return
        # sort ascending by distance from spawn point
        eventPlayer.perk_enemies_ = sorted(eventPlayer.perk_enemies_, key=lambda enemy: distance(enemy.getPosition(), getSpawnPoints(enemy.getTeam())[0]))

        # deal damage to all perk enemies without killing them
        for eventPlayer.perk_i in range(len(eventPlayer.perk_enemies_)):
            eventPlayer.perk_enemy_ = eventPlayer.perk_enemies_[eventPlayer.perk_i]
            eventPlayer.perk_hp_backup_ = eventPlayer.perk_enemy_.getHealth()

            # deal as much damage as possible
            eventPlayer.perk_enemy_.setStatusEffect(null, Status.UNKILLABLE, Math.INFINITY)
            damage(eventPlayer.perk_enemy_, eventPlayer, Math.INFINITY)
            eventPlayer.perk_points_ += (eventPlayer.perk_hp_backup_ - eventPlayer.perk_enemy_.getHealth())
            # restore enemy hp
            eventPlayer.perk_enemy_.setHealth(eventPlayer.perk_hp_backup_)
            eventPlayer.perk_enemy_.clearStatusEffect(Status.UNKILLABLE)

        # wait for tank ult charge compensation to trigger first
        wait()

    # restore ult charge
    eventPlayer.setUltCharge(eventPlayer.perk_ult_charge_backup_)


rule "[passives/perk.opy]: Unlock all perks after round starts":
    @Event eachPlayer
    @Condition eventPlayer.perk_points_ < eventPlayer.max_perk_points_
    @Condition not isInSetup()
    @Condition len([enemy for enemy in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if not enemy.isInSpawnRoom()]) > 0

    unlockAllPerks()
