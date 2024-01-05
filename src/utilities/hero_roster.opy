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


# Hardcode OW1 heroes = true, OW2 heroes = false by default
rule "[hero_roster.opy]: Initiaize hero roster workshop settings":
    heroes_enabled[heroID(Hero.DVA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "DVa", true)
    heroes_enabled[heroID(Hero.REINHARDT)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Reinhardt", true)
    heroes_enabled[heroID(Hero.WINSTON)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Winston", true)
    heroes_enabled[heroID(Hero.ZARYA)] = createWorkshopSetting(bool, "Hero Roster - Tank", "Zarya", true)
    
    heroes_enabled[heroID(Hero.ANA)] = createWorkshopSetting(bool, "Hero Roster - Support", "Ana", true)
    heroes_enabled[heroID(Hero.BRIGITTE)] = createWorkshopSetting(bool, "Hero Roster - Support", "Brigitte", true)
    heroes_enabled[heroID(Hero.LUCIO)] = createWorkshopSetting(bool, "Hero Roster - Support", "Lucio", true)
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
