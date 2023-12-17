#!mainFile "../main.opy"

globalvar hero_roster_gvar
#!defineMember current_hero hero_roster_gvar[0]
globalvar heroes_enabled

# Currently enabled heroes
#!defineMember tank_roaster hero_roster_gvar[1]
#!defineMember damage_roaster hero_roster_gvar[2]
#!defineMember support_roaster hero_roster_gvar[3]
#!defineMember hero_roaster hero_roster_gvar[4]

# Hero Role Definition
#!defineMember tank_heroes hero_roster_gvar[5]
#!defineMember damage_heroes hero_roster_gvar[6]
#!defineMember support_heroes hero_roster_gvar[7]


rule "[hero_roster.opy]: Initiaize hero roster workshop settings":
    heroes_enabled[heroID(Hero.DVA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "DVa", true)
    heroes_enabled[heroID(Hero.JUNKER_QUEEN)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Junker Queen", true)
    heroes_enabled[heroID(Hero.MAUGA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Mauga", false)
    heroes_enabled[heroID(Hero.ORISA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Orisa", true)
    heroes_enabled[heroID(Hero.RAMATTRA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Ramattra", true)
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
    heroes_enabled[heroID(Hero.SOJOURN)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Sojourn", true)
    heroes_enabled[heroID(Hero.SOLDIER)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Soldier", true)
    heroes_enabled[heroID(Hero.SOMBRA)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Sombra", true)
    heroes_enabled[heroID(Hero.SYMMETRA)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Symmetra", true)
    heroes_enabled[heroID(Hero.TORBJORN)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Torbjorn", true)
    heroes_enabled[heroID(Hero.TRACER)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Tracer", true)
    heroes_enabled[heroID(Hero.WIDOWMAKER)] = createWorkshopSetting(bool, "Hero Roster - Damage", "Widowmaker", true)
    
    heroes_enabled[heroID(Hero.ANA)] = createWorkshopSetting(bool, "Hero Roster - Support", "Ana", true)
    heroes_enabled[heroID(Hero.BAPTISTE)] = createWorkshopSetting(bool, "Hero Roster - Support", "Baptiste", true)
    heroes_enabled[heroID(Hero.BRIGITTE)] = createWorkshopSetting(bool, "Hero Roster - Support", "Brigitte", true)
    heroes_enabled[heroID(Hero.ILLARI)] = createWorkshopSetting(bool, "Hero Roster - Support", "Illari", false)
    heroes_enabled[heroID(Hero.KIRIKO)] = createWorkshopSetting(bool, "Hero Roster - Support", "Kiriko", true)
    heroes_enabled[heroID(Hero.LIFEWEAVER)] = createWorkshopSetting(bool, "Hero Roster - Support", "Lifeweaver", false)
    heroes_enabled[heroID(Hero.LUCIO)] = createWorkshopSetting(bool, "Hero Roster - Support", "Lucio", true)
    heroes_enabled[heroID(Hero.MERCY)] = createWorkshopSetting(bool, "Hero Roster - Support", "Mercy", true)
    heroes_enabled[heroID(Hero.MOIRA)] = createWorkshopSetting(bool, "Hero Roster - Support", "Moira", true)
    heroes_enabled[heroID(Hero.ZENYATTA)] = createWorkshopSetting(bool, "Hero Roster - Support", "Zenyatta", true)


rule "[hero_roster.opy]: Define tank, damage, support heroes array":
    # Tanks
    tank_heroes = getTankHeroes()
    tank_heroes.remove(Hero.DOOMFIST)

    # Damage
    damage_heroes = getDamageHeroes()
    damage_heroes.append(Hero.DOOMFIST)

    # Supports
    support_heroes = getSupportHeroes()

    tank_roaster = []
    damage_roaster = []
    support_roaster = []

    for i in range(len(getAllHeroes())):
        if (not heroes_enabled[i]): continue # Skip if hero not in roster
        
        current_hero = getAllHeroes()[i]
        if (current_hero in tank_heroes):
            tank_roaster.append(current_hero)
        elif (current_hero in damage_heroes):
            damage_roaster.append(current_hero)
        elif (current_hero in support_heroes):
            support_roaster.append(current_hero)

    hero_roaster = []
    hero_roaster.append(tank_roaster)
    hero_roaster.append(damage_roaster)
    hero_roaster.append(support_roaster)
