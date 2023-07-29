#!mainFile "../main.opy"

globalvar ow1_tank_heroes
globalvar ow1_damage_heroes
globalvar ow1_support_heroes

globalvar hero_select_time
globalvar max_tank_count = createWorkshopSetting(int[0:6], "Team Composition", "Tank", 2, 0)
globalvar max_damage_count = createWorkshopSetting(int[0:6], "Team Composition", "Damage", 2, 1)
globalvar max_support_count = createWorkshopSetting(int[0:6], "Team Composition", "Support", 2, 2)

playervar teammates
playervar tank_locked
playervar damage_locked
playervar support_locked

playervar allowed_heroes

playervar role
playervar team_composition

subroutine lockTank
subroutine lockDamage
subroutine lockSupport

subroutine unlockTank
subroutine unlockDamage
subroutine unlockSupport

enum Role:
    MISSING, # role has not been picked
    TANK,
    DAMAGE,
    SUPPORT


rule "[role_lock.opy]: Define OW1 tank, damage, support heroes":
    @Event global
    
    # Tanks
    ow1_tank_heroes = getTankHeroes()
    ow1_tank_heroes.remove([Hero.DOOMFIST, Hero.JUNKER_QUEEN, Hero.RAMATTRA])

    # Damage
    ow1_damage_heroes = getDamageHeroes()
    ow1_damage_heroes.append([Hero.DOOMFIST])
    ow1_damage_heroes.remove([Hero.SOJOURN])

    # Supports
    ow1_support_heroes = getSupportHeroes()
    ow1_support_heroes.remove([Hero.KIRIKO, Hero.LIFEWEAVER])


rule "[role_lock.opy]: Find player's role":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    if eventPlayer.getCurrentHero() in ow1_tank_heroes:
        eventPlayer.role = Role.TANK
    elif eventPlayer.getCurrentHero() in ow1_damage_heroes:
        eventPlayer.role = Role.DAMAGE
    elif eventPlayer.getCurrentHero() in ow1_support_heroes:
        eventPlayer.role = Role.SUPPORT
    else:
        eventPlayer.role = Role.MISSING


rule "[role_lock.opy]: Skip Assemble Heroes":
    @Event global
    @Condition isAssemblingHeroes() == true

    hero_select_time = getMatchTime() # Save assemble hero time
    setMatchTime(0) # Go to the end of the assembling heroes
    waitUntil(isAssemblingHeroes() == false, 9999)
    setMatchTime(getMatchTime() + hero_select_time) # Give back assemble hero time


rule "[role_lock.opy]: Unlock roles when assembling heroes":
    @Event eachPlayer
    @Condition isAssemblingHeroes() == true

    eventPlayer.tank_locked = false # Unlock tanks
    eventPlayer.damage_locked = false # Unlock damage
    eventPlayer.support_locked = false # Unlock supports


rule "[role_lock.opy]: Detect tank role limit (rising edge)":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.TANK))]) >= max_tank_count

    eventPlayer.tank_locked = true


rule "[role_lock.opy]: Detect damage role limit (rising edge)":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.DAMAGE))]) >= max_damage_count

    eventPlayer.damage_locked = true


rule "[role_lock.opy]: Detect support role limit (rising edge)":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.SUPPORT))]) >= max_support_count

    eventPlayer.support_locked = true


rule "[role_lock.opy]: Detect tank role limit (falling edge)":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.TANK))]) < max_tank_count

    eventPlayer.tank_locked = false


rule "[role_lock.opy]: Detect damage role limit (falling edge)":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.DAMAGE))]) < max_damage_count

    eventPlayer.damage_locked = false


rule "[role_lock.opy]: Detect support role limit (falling edge)":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.SUPPORT))]) < max_support_count

    eventPlayer.support_locked = false


rule "[role_lock.opy]: Start locking tank role":
    @Event eachPlayer
    @Condition eventPlayer.tank_locked == true

    lockTank()


rule "[role_lock.opy]: Start locking damage role":
    @Event eachPlayer
    @Condition eventPlayer.damage_locked == true

    lockDamage()


rule "[role_lock.opy]: Start locking support role":
    @Event eachPlayer
    @Condition eventPlayer.support_locked == true

    lockSupport()


rule "[role_lock.opy]: Stop locking tank role":
    @Event eachPlayer
    @Condition eventPlayer.tank_locked == false

    unlockTank()


rule "[role_lock.opy]: Stop locking damage role":
    @Event eachPlayer
    @Condition eventPlayer.damage_locked == false

    unlockDamage()


rule "[role_lock.opy]: Stop locking support role":
    @Event eachPlayer
    @Condition eventPlayer.support_locked == false

    unlockSupport()


def lockTank():
    @Name "[role_lock.opy]: lockTank()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.remove(ow1_tank_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def lockDamage():
    @Name "[role_lock.opy]: lockDamage()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.remove(ow1_damage_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def lockSupport():
    @Name "[role_lock.opy]: lockSupport()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.remove(ow1_support_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockTank():
    @Name "[role_lock.opy]: unlockTank()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.append(ow1_tank_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockDamage():
    @Name "[role_lock.opy]: unlockDamage()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.append(ow1_damage_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockSupport():
    @Name "[role_lock.opy]: unlockSupport()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.append(ow1_support_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)