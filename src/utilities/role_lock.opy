#!mainFile "../main.opy"

globalvar ow1_tank_heroes
globalvar ow1_damage_heroes
globalvar ow1_support_heroes

globalvar ow2_tank_heroes
globalvar ow2_damage_heroes
globalvar ow2_support_heroes

globalvar tank_heroes
globalvar damage_heroes
globalvar support_heroes
globalvar all_heroes

globalvar hero_select_time
globalvar max_tank_count = createWorkshopSetting(int[0:6], "Role limit", "Tank", 2, 0)
globalvar max_damage_count = createWorkshopSetting(int[0:6], "Role limit", "Damage", 2, 1)
globalvar max_support_count = createWorkshopSetting(int[0:6], "Role limit", "Support", 2, 2)
globalvar allow_ow1_heroes = createWorkshopSetting(bool, "Heroes", "Overwatch 1", true, 0)
globalvar allow_ow2_heroes = createWorkshopSetting(bool, "Heroes", "Overwatch 2", false, 0)

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


rule "[role_lock.opy]: Find player's role":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    waitUntil(not eventPlayer.hero_switched, Math.INFINITY)
    
    if eventPlayer.getCurrentHero() in tank_heroes:
        eventPlayer.role = Role.TANK
    elif eventPlayer.getCurrentHero() in damage_heroes:
        eventPlayer.role = Role.DAMAGE
    elif eventPlayer.getCurrentHero() in support_heroes:
        eventPlayer.role = Role.SUPPORT
    else:
        eventPlayer.role = Role.MISSING


rule "[role_lock.opy]: Define tank, damage, support heroes array":
    @Event global
    
    # Tanks
    ow1_tank_heroes = getTankHeroes()
    ow1_tank_heroes.remove(Hero.DOOMFIST)
    ow2_tank_heroes = [Hero.JUNKER_QUEEN, Hero.RAMATTRA]
    ow1_tank_heroes.remove(ow2_tank_heroes)

    # Damage
    ow1_damage_heroes = getDamageHeroes()
    ow1_damage_heroes.append(Hero.DOOMFIST)
    ow2_damage_heroes = [Hero.SOJOURN]
    ow1_damage_heroes.remove(ow2_damage_heroes)

    # Supports
    ow1_support_heroes = getSupportHeroes()
    ow2_support_heroes = [Hero.KIRIKO, Hero.LIFEWEAVER, Hero.ILLARI]
    ow1_support_heroes.remove(ow2_support_heroes)

    tank_heroes = []
    damage_heroes = []
    support_heroes = []

    if allow_ow1_heroes == true:
        tank_heroes.append(ow1_tank_heroes)
        damage_heroes.append(ow1_damage_heroes)
        support_heroes.append(ow1_support_heroes)

    if allow_ow2_heroes == true:
        tank_heroes.append(ow2_tank_heroes)
        damage_heroes.append(ow2_damage_heroes)
        support_heroes.append(ow2_support_heroes)

    all_heroes = []
    all_heroes.append(tank_heroes)
    all_heroes.append(damage_heroes)
    all_heroes.append(support_heroes)


rule "[role_lock.opy]: Override allowed heroes list when player joins lobby":
    @Event eachPlayer

    eventPlayer.setAllowedHeroes(all_heroes)


rule "[role_lock.opy]: Skip hero assembly":
    @Event global
    @Condition isAssemblingHeroes()

    getAllPlayers().role = Role.MISSING # Reset every player's role
    hero_select_time = getMatchTime() # Save assemble hero time
    setMatchTime(0) # Go to the end of the assembling heroes
    waitUntil(not isAssemblingHeroes(), Math.INFINITY)
    setMatchTime(getMatchTime() + hero_select_time) # Give back assemble hero time


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

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.remove(tank_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def lockDamage():
    @Name "[role_lock.opy]: lockDamage()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.remove(damage_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def lockSupport():
    @Name "[role_lock.opy]: lockSupport()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.remove(support_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockTank():
    @Name "[role_lock.opy]: unlockTank()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.append(tank_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockDamage():
    @Name "[role_lock.opy]: unlockDamage()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.append(damage_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)


def unlockSupport():
    @Name "[role_lock.opy]: unlockSupport()"

    eventPlayer.allowed_heroes = eventPlayer.getAllowedHeroes()
    eventPlayer.allowed_heroes.append(support_heroes)
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
