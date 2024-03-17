#!mainFile "../ow1pp_main.opy"

globalvar hero_roster_gvar
#!defineMember current_hero hero_roster_gvar[0]
globalvar heroes_enabled

# Currently enabled heroes
#!defineMember _available_tanks hero_roster_gvar[1]
#!defineMember _available_dps hero_roster_gvar[2]
#!defineMember _available_supports hero_roster_gvar[3]
#!defineMember _available_heroes hero_roster_gvar[4]

# Hero Role Definition
#!defineMember _tank_heroes hero_roster_gvar[5]
#!defineMember _damage_heroes hero_roster_gvar[6]
#!defineMember _support_heroes hero_roster_gvar[7]


rule "[hero_roster.opy]: Initiaize Hero Roster workshop settings":
    heroes_enabled[heroID(Hero.DVA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "DVa", true)
    heroes_enabled[heroID(Hero.JUNKER_QUEEN)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Junker Queen", ENABLE_JUNKERQUEEN)
    heroes_enabled[heroID(Hero.MAUGA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Mauga", ENABLE_MAUGA)
    heroes_enabled[heroID(Hero.ORISA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Orisa", true)
    heroes_enabled[heroID(Hero.RAMATTRA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Ramattra", ENABLE_RAMATTRA)
    heroes_enabled[heroID(Hero.REINHARDT)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Reinhardt", true)
    heroes_enabled[heroID(Hero.ROADHOG)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Roadhog", true)
    heroes_enabled[heroID(Hero.SIGMA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Sigma", true)
    heroes_enabled[heroID(Hero.WINSTON)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Winston", true)
    heroes_enabled[heroID(Hero.HAMMOND)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Wrecking Ball", true)
    heroes_enabled[heroID(Hero.ZARYA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Zarya", true)

    heroes_enabled[heroID(Hero.ASHE)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Ashe", true)
    heroes_enabled[heroID(Hero.BASTION)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Bastion", true)
    heroes_enabled[heroID(Hero.MCCREE)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Cassidy", true)
    heroes_enabled[heroID(Hero.DOOMFIST)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Doomfist", true)
    heroes_enabled[heroID(Hero.ECHO)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Echo", true)
    heroes_enabled[heroID(Hero.GENJI)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Genji", true)
    heroes_enabled[heroID(Hero.HANZO)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Hanzo", true)
    heroes_enabled[heroID(Hero.JUNKRAT)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Junkrat", true)
    heroes_enabled[heroID(Hero.MEI)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Mei", true)
    heroes_enabled[heroID(Hero.PHARAH)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Pharah", true)
    heroes_enabled[heroID(Hero.REAPER)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Reaper", true)
    heroes_enabled[heroID(Hero.SOJOURN)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Sojourn", ENABLE_SOJOURN)
    heroes_enabled[heroID(Hero.SOLDIER)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Soldier", true)
    heroes_enabled[heroID(Hero.SOMBRA)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Sombra", true)
    heroes_enabled[heroID(Hero.SYMMETRA)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Symmetra", true)
    heroes_enabled[heroID(Hero.TORBJORN)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Torbjorn", true)
    heroes_enabled[heroID(Hero.TRACER)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Tracer", true)
    heroes_enabled[heroID(Hero.WIDOWMAKER)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Widowmaker", true)
    
    heroes_enabled[heroID(Hero.ANA)] = createWorkshopSetting(bool, "Hero Roster - Support", "Ana", true)
    heroes_enabled[heroID(Hero.BAPTISTE)] = createWorkshopSetting(bool, "Hero Roster - Support", "Baptiste", true)
    heroes_enabled[heroID(Hero.BRIGITTE)] = createWorkshopSetting(bool, "Hero Roster - Support", "Brigitte", true)
    heroes_enabled[heroID(Hero.ILLARI)] = createWorkshopSetting(bool, "Hero Roster - Support", "Illari", ENABLE_ILLARI)
    heroes_enabled[heroID(Hero.KIRIKO)] = createWorkshopSetting(bool, "Hero Roster - Support", "Kiriko", ENABLE_KIRIKO)
    heroes_enabled[heroID(Hero.LIFEWEAVER)] = createWorkshopSetting(bool, "Hero Roster - Support", "Lifeweaver", ENABLE_LIFEWEAVER)
    heroes_enabled[heroID(Hero.LUCIO)] = createWorkshopSetting(bool, "Hero Roster - Support", "Lucio", true)
    heroes_enabled[heroID(Hero.MERCY)] = createWorkshopSetting(bool, "Hero Roster - Support", "Mercy", true)
    heroes_enabled[heroID(Hero.MOIRA)] = createWorkshopSetting(bool, "Hero Roster - Support", "Moira", true)
    heroes_enabled[heroID(Hero.ZENYATTA)] = createWorkshopSetting(bool, "Hero Roster - Support", "Zenyatta", true)


rule "[hero_roster.opy]: Define tank, damage, support heroes array":
    # Tanks
    _tank_heroes = getTankHeroes()
    _tank_heroes.remove(Hero.DOOMFIST)

    # Damage
    _damage_heroes = getDamageHeroes()
    _damage_heroes.append(Hero.DOOMFIST)

    # Supports
    _support_heroes = getSupportHeroes()

    _available_tanks = []
    _available_dps = []
    _available_supports = []

    for i in range(len(getAllHeroes())):
        if (not heroes_enabled[i]): continue # Skip if hero not enabled
        
        current_hero = getAllHeroes()[i]
        if (current_hero in _tank_heroes):
            _available_tanks.append(current_hero)
        elif (current_hero in _damage_heroes):
            _available_dps.append(current_hero)
        elif (current_hero in _support_heroes):
            _available_supports.append(current_hero)

    _available_heroes = []
    _available_heroes.append(_available_tanks)
    _available_heroes.append(_available_dps)
    _available_heroes.append(_available_supports)
