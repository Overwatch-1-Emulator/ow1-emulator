# #!mainFile "../main.opy"

playervar last_hero_played
playervar hero_switched
playervar hero_id
playervar initialized
playervar assemble_team
playervar team_correct

globalvar assemble_team
globalvar hero_list_damage
globalvar hero_list_support
globalvar hero_list_tank
globalvar list_hero
globalvar role_limit_damage
globalvar role_limit_support
globalvar role_limit_tank
globalvar respawn_character





rule "[hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.last_hero_played != eventPlayer.getCurrentHero()
    
    eventPlayer.hero_switched = true
    wait()
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer.hero_id = heroID(eventPlayer.last_hero_played)
    eventPlayer.hero_switched = false

rule "[hero_switch.opy]: Remove OW2 heroes and change Doomfist to DPS":
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

rule "[hero_switch.opy]: No Assemble Heroes":
    @Condition isAssemblingHeroes() == true

    # Go to the end of the assembling heroes
    setMatchTime(0)
    # Wait a little to hero to spawn
    wait()
    # Pause match time to wait for the heroes to be chosen
    pauseMatchTime()
    # 30 seconds to choose your character
    wait(30)
    # Make every hero respawn to be in their spawn and start the match
    respawn_character = true
    wait()
    respawn_character = false
    unpauseMatchTime()
    

rule "[hero_switch.opy]: Respawn hero to start the match":
    @Event eachPlayer
    @Condition respawn_character == true
    
    eventPlayer.respawn()

    
rule "[hero_switch.opy]: Role limit lockout damage":
    @Event eachPlayer
    @Condition (eventPlayer.getCurrentHero() in hero_list_damage) 
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_damage]) >= role_limit_damage
    @Condition eventPlayer.hero_switched

    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_damage))

rule "[hero_switch.opy]: Role limit lockout damage":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_damage]) >= role_limit_damage
    @Condition (eventPlayer.getCurrentHero() in hero_list_damage) == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_damage))


rule "[hero_switch.opy]: Role limit enable damage":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_damage]) < role_limit_damage
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(hero_list_damage))


rule "[hero_switch.opy]: Role limit lockout tank":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_tank]) >= role_limit_tank
    @Condition (eventPlayer.getCurrentHero() in hero_list_tank) == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_tank))


rule "[hero_switch.opy]: Role limit enable tank":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_tank]) < role_limit_tank
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(hero_list_tank))


rule "[hero_switch.opy]: Role limit lockout support":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_support]) >= role_limit_support
    @Condition (eventPlayer.getCurrentHero() in hero_list_support) == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_support))


rule "[hero_switch.opy]: Role limit enable support":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_support]) < role_limit_support
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(hero_list_support))