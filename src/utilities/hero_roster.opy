#!mainFile "../main.opy"

globalvar hero_roaster_gvar
#!defineMember current_hero hero_roaster_gvar[0]
globalvar heroes_enabled

# Currently enabled heroes
#!defineMember tank_roaster hero_roaster_gvar[1]
#!defineMember damage_roaster hero_roaster_gvar[2]
#!defineMember support_roaster hero_roaster_gvar[3]
#!defineMember hero_roaster hero_roaster_gvar[4]

# Hero Role Definition
#!defineMember tank_heroes hero_roaster_gvar[5]
#!defineMember damage_heroes hero_roaster_gvar[6]
#!defineMember support_heroes hero_roaster_gvar[7]


# Hardcode OW1 heroes = true, OW2 heroes = false by default
rule "[hero_roster.opy]: Initiaize hero roster workshop settings":
    heroes_enabled[heroID(Hero.ANA)] = createWorkshopSetting(bool, "Hero Roster", "Ana", false, 0)
    heroes_enabled[heroID(Hero.ASHE)] = createWorkshopSetting(bool, "Hero Roster", "Ashe", false, 0)
    heroes_enabled[heroID(Hero.BAPTISTE)] = createWorkshopSetting(bool, "Hero Roster", "Baptiste", false, 0)
    heroes_enabled[heroID(Hero.BASTION)] = createWorkshopSetting(bool, "Hero Roster", "Bastion", false, 0)
    heroes_enabled[heroID(Hero.BRIGITTE)] = createWorkshopSetting(bool, "Hero Roster", "Brigitte", true, 0)
    heroes_enabled[heroID(Hero.MCCREE)] = createWorkshopSetting(bool, "Hero Roster", "Cassidy", false, 0)
    heroes_enabled[heroID(Hero.DOOMFIST)] = createWorkshopSetting(bool, "Hero Roster", "Doomfist", false, 0)
    heroes_enabled[heroID(Hero.DVA)] = createWorkshopSetting(bool, "Hero Roster", "DVa", true, 0)
    heroes_enabled[heroID(Hero.ECHO)] = createWorkshopSetting(bool, "Hero Roster", "Echo", false, 0)
    heroes_enabled[heroID(Hero.GENJI)] = createWorkshopSetting(bool, "Hero Roster", "Genji", false, 0)
    heroes_enabled[heroID(Hero.HANZO)] = createWorkshopSetting(bool, "Hero Roster", "Hanzo", false, 0)
    heroes_enabled[heroID(Hero.ILLARI)] = createWorkshopSetting(bool, "Hero Roster", "Illari", false, 0)
    heroes_enabled[heroID(Hero.JUNKER_QUEEN)] = createWorkshopSetting(bool, "Hero Roster", "Junker_queen", false, 0)
    heroes_enabled[heroID(Hero.JUNKRAT)] = createWorkshopSetting(bool, "Hero Roster", "Junkrat", false, 0)
    heroes_enabled[heroID(Hero.KIRIKO)] = createWorkshopSetting(bool, "Hero Roster", "Kiriko", false, 0)
    heroes_enabled[heroID(Hero.LIFEWEAVER)] = createWorkshopSetting(bool, "Hero Roster", "Lifeweaver", false, 0)
    heroes_enabled[heroID(Hero.LUCIO)] = createWorkshopSetting(bool, "Hero Roster", "Lucio", true, 0)
    heroes_enabled[heroID(Hero.MEI)] = createWorkshopSetting(bool, "Hero Roster", "Mei", false, 0)
    heroes_enabled[heroID(Hero.MERCY)] = createWorkshopSetting(bool, "Hero Roster", "Mercy", false, 0)
    heroes_enabled[heroID(Hero.MOIRA)] = createWorkshopSetting(bool, "Hero Roster", "Moira", false, 0)
    heroes_enabled[heroID(Hero.ORISA)] = createWorkshopSetting(bool, "Hero Roster", "Orisa", false, 0)
    heroes_enabled[heroID(Hero.PHARAH)] = createWorkshopSetting(bool, "Hero Roster", "Pharah", false, 0)
    heroes_enabled[heroID(Hero.RAMATTRA)] = createWorkshopSetting(bool, "Hero Roster", "Ramattra", false, 0)
    heroes_enabled[heroID(Hero.REAPER)] = createWorkshopSetting(bool, "Hero Roster", "Reaper", false, 0)
    heroes_enabled[heroID(Hero.REINHARDT)] = createWorkshopSetting(bool, "Hero Roster", "Reinhardt", true, 0)
    heroes_enabled[heroID(Hero.ROADHOG)] = createWorkshopSetting(bool, "Hero Roster", "Roadhog", false, 0)
    heroes_enabled[heroID(Hero.SIGMA)] = createWorkshopSetting(bool, "Hero Roster", "Sigma", false, 0)
    heroes_enabled[heroID(Hero.SOJOURN)] = createWorkshopSetting(bool, "Hero Roster", "Sojourn", false, 0)
    heroes_enabled[heroID(Hero.SOLDIER)] = createWorkshopSetting(bool, "Hero Roster", "Soldier", false, 0)
    heroes_enabled[heroID(Hero.SOMBRA)] = createWorkshopSetting(bool, "Hero Roster", "Sombra", false, 0)
    heroes_enabled[heroID(Hero.SYMMETRA)] = createWorkshopSetting(bool, "Hero Roster", "Symmetra", false, 0)
    heroes_enabled[heroID(Hero.TORBJORN)] = createWorkshopSetting(bool, "Hero Roster", "Torbjorn", false, 0)
    heroes_enabled[heroID(Hero.TRACER)] = createWorkshopSetting(bool, "Hero Roster", "Tracer", false, 0)
    heroes_enabled[heroID(Hero.WIDOWMAKER)] = createWorkshopSetting(bool, "Hero Roster", "Widowmaker", false, 0)
    heroes_enabled[heroID(Hero.WINSTON)] = createWorkshopSetting(bool, "Hero Roster", "Winston", false, 0)
    heroes_enabled[heroID(Hero.HAMMOND)] = createWorkshopSetting(bool, "Hero Roster", "Wrecking Ball", false, 0)
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

    tank_roaster = []
    damage_roaster = []
    support_roaster = []

    for i in range(len(getAllHeroes())):
        if (not heroes_enabled[i]):
            continue # Skip if hero not in roster
        
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
