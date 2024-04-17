#!mainFile "../dev_main.opy"

# indexing variable
globalvar hero_roster_i

globalvar hero_roster_gvar
#!defineMember _current_hero hero_roster_gvar[0]
# Currently enabled heroes
#!defineMember _available_tanks hero_roster_gvar[1]
#!defineMember _available_dps hero_roster_gvar[2]
#!defineMember _available_supports hero_roster_gvar[3]
#!defineMember _available_heroes hero_roster_gvar[4]
# Hero Role Definition
#!defineMember _tank_heroes hero_roster_gvar[5]
#!defineMember _damage_heroes hero_roster_gvar[6]
#!defineMember _support_heroes hero_roster_gvar[7]

#!define getOW1TankHeroes() _tank_heroes
#!define getOW1DamageHeroes() _damage_heroes
#!define getOW1SupportHeroes() _support_heroes


rule "[utilities/hero_roster.opy]: Custom role definition":
    @Condition _available_heroes == null
    @Condition len(getAllPlayers().getAllowedHeroes()) > 0

    _available_heroes = getAllPlayers().getAllowedHeroes()

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

    for hero_roster_i in range(len(_available_heroes)):
        _current_hero = _available_heroes[hero_roster_i]
        if (_current_hero in _tank_heroes):
            _available_tanks.append(_current_hero)
        elif (_current_hero in _damage_heroes):
            _available_dps.append(_current_hero)
        elif (_current_hero in _support_heroes):
            _available_supports.append(_current_hero)
