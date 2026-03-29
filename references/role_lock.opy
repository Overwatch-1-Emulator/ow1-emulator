/*
    Written by Maxwell Jung in 2023 for Overwatch 1 Emulator (KHTG0)
    Sourced from ow1_emulator v0.11.1
*/

globalvar i
globalvar hero_select_time
globalvar max_tank_count = createWorkshopSetting(int[0:6], "Role limit", "Tank", 2, 0)
globalvar max_damage_count = createWorkshopSetting(int[0:6], "Role limit", "Damage", 2, 1)
globalvar max_support_count = createWorkshopSetting(int[0:6], "Role limit", "Support", 2, 2)
globalvar heroes_enabled

# Currently enabled heroes
globalvar tank_roaster
globalvar damage_roaster
globalvar support_roaster
globalvar hero_roaster

# Hero Role Definition
globalvar tank_heroes
globalvar damage_heroes
globalvar support_heroes

playervar last_hero_played
playervar hero_switched

playervar role
playervar allowed_heroes

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

#!define heroID(h) getAllHeroes().index(h)

rule "[hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.last_hero_played != eventPlayer.getCurrentHero()
    
    eventPlayer.hero_switched = true
    wait()
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer.hero_switched = false


# Hardcode OW1 heroes = true, OW2 heroes = false by default
rule "[hero_roster.opy]: Initiaize hero roster workshop settings":
    heroes_enabled[heroID(Hero.ANA)] = createWorkshopSetting(bool, "Hero Roster", "Ana", true, 0)
    heroes_enabled[heroID(Hero.ASHE)] = createWorkshopSetting(bool, "Hero Roster", "Ashe", true, 0)
    heroes_enabled[heroID(Hero.BAPTISTE)] = createWorkshopSetting(bool, "Hero Roster", "Baptiste", true, 0)
    heroes_enabled[heroID(Hero.BASTION)] = createWorkshopSetting(bool, "Hero Roster", "Bastion", true, 0)
    heroes_enabled[heroID(Hero.BRIGITTE)] = createWorkshopSetting(bool, "Hero Roster", "Brigitte", true, 0)
    heroes_enabled[heroID(Hero.MCCREE)] = createWorkshopSetting(bool, "Hero Roster", "Cassidy", true, 0)
    heroes_enabled[heroID(Hero.DOOMFIST)] = createWorkshopSetting(bool, "Hero Roster", "Doomfist", true, 0)
    heroes_enabled[heroID(Hero.DVA)] = createWorkshopSetting(bool, "Hero Roster", "DVa", true, 0)
    heroes_enabled[heroID(Hero.ECHO)] = createWorkshopSetting(bool, "Hero Roster", "Echo", true, 0)
    heroes_enabled[heroID(Hero.GENJI)] = createWorkshopSetting(bool, "Hero Roster", "Genji", true, 0)
    heroes_enabled[heroID(Hero.HANZO)] = createWorkshopSetting(bool, "Hero Roster", "Hanzo", true, 0)
    heroes_enabled[heroID(Hero.ILLARI)] = createWorkshopSetting(bool, "Hero Roster", "Illari", true, 0)
    heroes_enabled[heroID(Hero.JUNKER_QUEEN)] = createWorkshopSetting(bool, "Hero Roster", "Junker_queen", true, 0)
    heroes_enabled[heroID(Hero.JUNKRAT)] = createWorkshopSetting(bool, "Hero Roster", "Junkrat", true, 0)
    heroes_enabled[heroID(Hero.KIRIKO)] = createWorkshopSetting(bool, "Hero Roster", "Kiriko", true, 0)
    heroes_enabled[heroID(Hero.LIFEWEAVER)] = createWorkshopSetting(bool, "Hero Roster", "Lifeweaver", true, 0)
    heroes_enabled[heroID(Hero.LUCIO)] = createWorkshopSetting(bool, "Hero Roster", "Lucio", true, 0)
    heroes_enabled[heroID(Hero.MEI)] = createWorkshopSetting(bool, "Hero Roster", "Mei", true, 0)
    heroes_enabled[heroID(Hero.MERCY)] = createWorkshopSetting(bool, "Hero Roster", "Mercy", true, 0)
    heroes_enabled[heroID(Hero.MOIRA)] = createWorkshopSetting(bool, "Hero Roster", "Moira", true, 0)
    heroes_enabled[heroID(Hero.ORISA)] = createWorkshopSetting(bool, "Hero Roster", "Orisa", true, 0)
    heroes_enabled[heroID(Hero.PHARAH)] = createWorkshopSetting(bool, "Hero Roster", "Pharah", true, 0)
    heroes_enabled[heroID(Hero.RAMATTRA)] = createWorkshopSetting(bool, "Hero Roster", "Ramattra", true, 0)
    heroes_enabled[heroID(Hero.REAPER)] = createWorkshopSetting(bool, "Hero Roster", "Reaper", true, 0)
    heroes_enabled[heroID(Hero.REINHARDT)] = createWorkshopSetting(bool, "Hero Roster", "Reinhardt", true, 0)
    heroes_enabled[heroID(Hero.ROADHOG)] = createWorkshopSetting(bool, "Hero Roster", "Roadhog", true, 0)
    heroes_enabled[heroID(Hero.SIGMA)] = createWorkshopSetting(bool, "Hero Roster", "Sigma", true, 0)
    heroes_enabled[heroID(Hero.SOJOURN)] = createWorkshopSetting(bool, "Hero Roster", "Sojourn", true, 0)
    heroes_enabled[heroID(Hero.SOLDIER)] = createWorkshopSetting(bool, "Hero Roster", "Soldier", true, 0)
    heroes_enabled[heroID(Hero.SOMBRA)] = createWorkshopSetting(bool, "Hero Roster", "Sombra", true, 0)
    heroes_enabled[heroID(Hero.SYMMETRA)] = createWorkshopSetting(bool, "Hero Roster", "Symmetra", true, 0)
    heroes_enabled[heroID(Hero.TORBJORN)] = createWorkshopSetting(bool, "Hero Roster", "Torbjorn", true, 0)
    heroes_enabled[heroID(Hero.TRACER)] = createWorkshopSetting(bool, "Hero Roster", "Tracer", true, 0)
    heroes_enabled[heroID(Hero.WIDOWMAKER)] = createWorkshopSetting(bool, "Hero Roster", "Widowmaker", true, 0)
    heroes_enabled[heroID(Hero.WINSTON)] = createWorkshopSetting(bool, "Hero Roster", "Winston", true, 0)
    heroes_enabled[heroID(Hero.HAMMOND)] = createWorkshopSetting(bool, "Hero Roster", "Wrecking Ball", true, 0)
    heroes_enabled[heroID(Hero.ZARYA)] = createWorkshopSetting(bool, "Hero Roster", "Zarya", true, 0)
    heroes_enabled[heroID(Hero.ZENYATTA)] = createWorkshopSetting(bool, "Hero Roster", "Zenyatta", true, 0)


rule "[hero_roster.opy]: Define tank, damage, support heroes array":
    @Event global
    
    # Tanks
    tank_heroes = getTankHeroes()
    tank_heroes.remove(Hero.DOOMFIST)

    # Damage
    damage_heroes = getDamageHeroes()
    damage_heroes.append(Hero.DOOMFIST)

    # Supports
    support_heroes = getSupportHeroes()

    # Put enabled heroes into roaster
    tank_roaster = []
    damage_roaster = []
    support_roaster = []

    for i in range(len(getAllHeroes())):
        if (heroes_enabled[i]):
            if (getAllHeroes()[i] in tank_heroes):
                tank_roaster.append(getAllHeroes()[i])
            elif (getAllHeroes()[i] in damage_heroes):
                damage_roaster.append(getAllHeroes()[i])
            elif (getAllHeroes()[i] in support_heroes):
                support_roaster.append(getAllHeroes()[i])
        

    hero_roaster = []
    hero_roaster.append(tank_roaster)
    hero_roaster.append(damage_roaster)
    hero_roaster.append(support_roaster)


rule "[role_lock.opy]: Find player's role":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched
    
    if eventPlayer.getCurrentHero() in tank_heroes:
        eventPlayer.role = Role.TANK
    elif eventPlayer.getCurrentHero() in damage_heroes:
        eventPlayer.role = Role.DAMAGE
    elif eventPlayer.getCurrentHero() in support_heroes:
        eventPlayer.role = Role.SUPPORT
    else:
        eventPlayer.role = Role.MISSING


rule "[role_lock.opy]: Override allowed heroes list when player joins lobby":
    @Event eachPlayer

    eventPlayer.allowed_heroes = hero_roaster
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


rule "[role_lock.opy]: Skip hero assembly":
    @Event global
    @Condition isAssemblingHeroes()

    getAllPlayers().role = Role.MISSING # Reset every player's role
    hero_select_time = getMatchTime() # Save assemble hero time
    wait()
    setMatchTime(0) # Go to the end of the assembling heroes
    waitUntil(not isAssemblingHeroes(), Math.INFINITY)
    setMatchTime(getMatchTime() + hero_select_time/3) # Give back assemble hero time


rule "[role_lock.opy]: Lock tanks above role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.TANK))]) >= max_tank_count
    @Condition not isAssemblingHeroes()

    lockTank()


rule "[role_lock.opy]: Lock damage above role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.DAMAGE))]) >= max_damage_count
    @Condition not isAssemblingHeroes()

    lockDamage()


rule "[role_lock.opy]: Lock supports above role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.SUPPORT))]) >= max_support_count
    @Condition not isAssemblingHeroes()

    lockSupport()


rule "[role_lock.opy]: Unlock tanks below role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.TANK))]) < max_tank_count
    @Condition not isAssemblingHeroes()

    unlockTank()


rule "[role_lock.opy]: Unlock damage below role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.DAMAGE))]) < max_damage_count
    @Condition not isAssemblingHeroes()

    unlockDamage()


rule "[role_lock.opy]: Unlock supports below role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.SUPPORT))]) < max_support_count
    @Condition not isAssemblingHeroes()

    unlockSupport()


def lockTank():
    @Name "[role_lock.opy]: lockTank()"

    eventPlayer.allowed_heroes.remove(tank_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def lockDamage():
    @Name "[role_lock.opy]: lockDamage()"

    eventPlayer.allowed_heroes.remove(damage_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def lockSupport():
    @Name "[role_lock.opy]: lockSupport()"

    eventPlayer.allowed_heroes.remove(support_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockTank():
    @Name "[role_lock.opy]: unlockTank()"

    eventPlayer.allowed_heroes.append(tank_roaster)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockDamage():
    @Name "[role_lock.opy]: unlockDamage()"

    eventPlayer.allowed_heroes.append(damage_roaster)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockSupport():
    @Name "[role_lock.opy]: unlockSupport()"

    eventPlayer.allowed_heroes.append(support_roaster)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
