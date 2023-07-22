#!mainFile "../main.opy"

# Code based on Role Limit Framework by Josbird#1908  (jprosk#6749 on Discord) https://workshop.codes/DN8PX
#Global variables

globalvar hero_list_damage
globalvar hero_list_tank
globalvar hero_list_support
globalvar role_limit_damage
globalvar role_limit_tank
globalvar role_limit_support

rule "[role_limit.opy]: Remove OW2 heroes and change Doomfist to DPS":
    hero_list_damage = getDamageHeroes()
    hero_list_damage.append([Hero.DOOMFIST])
    hero_list_damage.remove([Hero.SOJOURN])
    hero_list_tank = getTankHeroes()
    hero_list_tank.remove([Hero.DOOMFIST,Hero.JUNKER_QUEEN,Hero.RAMATTRA])
    hero_list_support = getSupportHeroes()
    hero_list_support.remove([Hero.KIRIKO,Hero.LIFEWEAVER])
    role_limit_damage = 2
    role_limit_tank = 2
    role_limit_support = 2


rule "[role_limit.opy]: Role limit lockout damage":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_damage]) >= role_limit_damage
    @Condition (eventPlayer.getCurrentHero() in hero_list_damage) == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_damage))


rule "[role_limit.opy]: Role limit enable damage":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_damage]) < role_limit_damage
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(hero_list_damage))


rule "[role_limit.opy]: Role limit lockout tank":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_tank]) >= role_limit_tank
    @Condition (eventPlayer.getCurrentHero() in hero_list_tank) == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_tank))


rule "[role_limit.opy]: Role limit enable tank":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_tank]) < role_limit_tank
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(hero_list_tank))


rule "[role_limit.opy]: Role limit lockout support":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_support]) >= role_limit_support
    @Condition (eventPlayer.getCurrentHero() in hero_list_support) == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_support))


rule "[role_limit.opy]: Role limit enable support":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_support]) < role_limit_support
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(hero_list_support))