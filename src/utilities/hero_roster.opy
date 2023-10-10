#!mainFile "../main.opy"

globalvar heroes_enabled
globalvar current_hero

# Currently enabled heroes
globalvar tank_roaster
globalvar damage_roaster
globalvar support_roaster
globalvar hero_roaster

# Hero Role Definition
globalvar tank_heroes
globalvar damage_heroes
globalvar support_heroes

# Hardcode OW1 heroes = true, OW2 heroes = false by default
rule "[utilities/hero_roster.opy]: Initiaize hero roster workshop settings":
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
    heroes_enabled[heroID(Hero.ILLARI)] = createWorkshopSetting(bool, "Hero Roster", "Illari", false, 0)
    heroes_enabled[heroID(Hero.JUNKER_QUEEN)] = createWorkshopSetting(bool, "Hero Roster", "Junker_queen", false, 0)
    heroes_enabled[heroID(Hero.JUNKRAT)] = createWorkshopSetting(bool, "Hero Roster", "Junkrat", true, 0)
    heroes_enabled[heroID(Hero.KIRIKO)] = createWorkshopSetting(bool, "Hero Roster", "Kiriko", false, 0)
    heroes_enabled[heroID(Hero.LIFEWEAVER)] = createWorkshopSetting(bool, "Hero Roster", "Lifeweaver", false, 0)
    heroes_enabled[heroID(Hero.LUCIO)] = createWorkshopSetting(bool, "Hero Roster", "Lucio", true, 0)
    heroes_enabled[heroID(Hero.MEI)] = createWorkshopSetting(bool, "Hero Roster", "Mei", true, 0)
    heroes_enabled[heroID(Hero.MERCY)] = createWorkshopSetting(bool, "Hero Roster", "Mercy", true, 0)
    heroes_enabled[heroID(Hero.MOIRA)] = createWorkshopSetting(bool, "Hero Roster", "Moira", true, 0)
    heroes_enabled[heroID(Hero.ORISA)] = createWorkshopSetting(bool, "Hero Roster", "Orisa", true, 0)
    heroes_enabled[heroID(Hero.PHARAH)] = createWorkshopSetting(bool, "Hero Roster", "Pharah", true, 0)
    heroes_enabled[heroID(Hero.RAMATTRA)] = createWorkshopSetting(bool, "Hero Roster", "Ramattra", false, 0)
    heroes_enabled[heroID(Hero.REAPER)] = createWorkshopSetting(bool, "Hero Roster", "Reaper", true, 0)
    heroes_enabled[heroID(Hero.REINHARDT)] = createWorkshopSetting(bool, "Hero Roster", "Reinhardt", true, 0)
    heroes_enabled[heroID(Hero.ROADHOG)] = createWorkshopSetting(bool, "Hero Roster", "Roadhog", true, 0)
    heroes_enabled[heroID(Hero.SIGMA)] = createWorkshopSetting(bool, "Hero Roster", "Sigma", true, 0)
    heroes_enabled[heroID(Hero.SOJOURN)] = createWorkshopSetting(bool, "Hero Roster", "Sojourn", false, 0)
    heroes_enabled[heroID(Hero.SOLDIER)] = createWorkshopSetting(bool, "Hero Roster", "Soldier", true, 0)
    heroes_enabled[heroID(Hero.SOMBRA)] = createWorkshopSetting(bool, "Hero Roster", "Sombra", false, 0)
    heroes_enabled[heroID(Hero.SYMMETRA)] = createWorkshopSetting(bool, "Hero Roster", "Symmetra", true, 0)
    heroes_enabled[heroID(Hero.TORBJORN)] = createWorkshopSetting(bool, "Hero Roster", "Torbjorn", true, 0)
    heroes_enabled[heroID(Hero.TRACER)] = createWorkshopSetting(bool, "Hero Roster", "Tracer", true, 0)
    heroes_enabled[heroID(Hero.WIDOWMAKER)] = createWorkshopSetting(bool, "Hero Roster", "Widowmaker", true, 0)
    heroes_enabled[heroID(Hero.WINSTON)] = createWorkshopSetting(bool, "Hero Roster", "Winston", true, 0)
    heroes_enabled[heroID(Hero.HAMMOND)] = createWorkshopSetting(bool, "Hero Roster", "Wrecking Ball", true, 0)
    heroes_enabled[heroID(Hero.ZARYA)] = createWorkshopSetting(bool, "Hero Roster", "Zarya", true, 0)
    heroes_enabled[heroID(Hero.ZENYATTA)] = createWorkshopSetting(bool, "Hero Roster", "Zenyatta", true, 0)


rule "[utilities/hero_roster.opy]: Define tank, damage, support heroes array":
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
