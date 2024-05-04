#!mainFile "../dev_main.opy"

globalvar role_lock_gvar
#!defineMember _hero_select_time role_lock_gvar[0]
#!defineMember MAX_TANK_COUNT role_lock_gvar[1]
#!defineMember MAX_DAMAGE_COUNT role_lock_gvar[2]
#!defineMember MAX_SUPPORT_COUNT role_lock_gvar[3]

rule "[utilities/role_lock.opy]: Initialize global variables":
    MAX_TANK_COUNT = createWorkshopSetting(int[0:12], "Role limit", "Tank", 2, 0)
    MAX_DAMAGE_COUNT = createWorkshopSetting(int[0:12], "Role limit", "Damage", 2, 1)
    MAX_SUPPORT_COUNT = createWorkshopSetting(int[0:12], "Role limit", "Support", 2, 2)

playervar role_lock_pvar
#!defineMember role role_lock_pvar[0]
#!defineMember allowed_heroes role_lock_pvar[1]

enum Role:
    MISSING, # role has not been picked
    TANK,
    DAMAGE,
    SUPPORT


rule "[utilities/role_lock.opy]: Find player's role":
    @Event eachPlayer
    @Condition switchedHero(eventPlayer)
    
    if eventPlayer.getCurrentHero() in getOW1TankHeroes():
        eventPlayer.role = Role.TANK
    elif eventPlayer.getCurrentHero() in getOW1DamageHeroes():
        eventPlayer.role = Role.DAMAGE
    elif eventPlayer.getCurrentHero() in getOW1SupportHeroes():
        eventPlayer.role = Role.SUPPORT
    else:
        eventPlayer.role = Role.MISSING


rule "[utilities/role_lock.opy]: Override allowed heroes list when player joins lobby":
    @Event eachPlayer

    eventPlayer.allowed_heroes = _available_heroes
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


rule "[utilities/role_lock.opy]: Skip hero assembly":
    @Event global
    @Condition isAssemblingHeroes()

    getAllPlayers().role = Role.MISSING # Reset every player's role
    _hero_select_time = getMatchTime() # Save assemble hero time
    wait()
    setMatchTime(0) # Go to the end of the assembling heroes
    waitUntil(not isAssemblingHeroes(), Math.INFINITY)
    setMatchTime(getMatchTime() + _hero_select_time/3) # Give back assemble hero time


rule "[utilities/role_lock.opy]: Lock tanks above role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.TANK))]) >= MAX_TANK_COUNT
    @Condition not isAssemblingHeroes()

    eventPlayer.allowed_heroes.remove(getOW1TankHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


rule "[utilities/role_lock.opy]: Lock damage above role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.DAMAGE))]) >= MAX_DAMAGE_COUNT
    @Condition not isAssemblingHeroes()

    eventPlayer.allowed_heroes.remove(getOW1DamageHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


rule "[utilities/role_lock.opy]: Lock supports above role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.SUPPORT))]) >= MAX_SUPPORT_COUNT
    @Condition not isAssemblingHeroes()

    eventPlayer.allowed_heroes.remove(getOW1SupportHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


rule "[utilities/role_lock.opy]: Unlock tanks below role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.TANK))]) < MAX_TANK_COUNT
    @Condition not isAssemblingHeroes()

    eventPlayer.allowed_heroes.append(_available_tanks)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


rule "[utilities/role_lock.opy]: Unlock damage below role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.DAMAGE))]) < MAX_DAMAGE_COUNT
    @Condition not isAssemblingHeroes()

    eventPlayer.allowed_heroes.append(_available_dps)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


rule "[utilities/role_lock.opy]: Unlock supports below role limit":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if ((player != eventPlayer) and (player.role == Role.SUPPORT))]) < MAX_SUPPORT_COUNT
    @Condition not isAssemblingHeroes()

    eventPlayer.allowed_heroes.append(_available_supports)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
