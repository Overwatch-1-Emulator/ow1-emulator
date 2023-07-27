# #!mainFile "../main.opy"

playervar last_hero_played
playervar hero_switched
playervar hero_id
playervar initialized
playervar role_lock

globalvar hero_list_damage
globalvar hero_list_support
globalvar hero_list_tank
globalvar list_hero
globalvar respawn_character
globalvar role_limit_damage = createWorkshopSetting(int[0:6],"Role","Damage Player",2,0)
globalvar role_limit_support = createWorkshopSetting(int[0:6],"Role","Support Player",2,0)
globalvar role_limit_tank = createWorkshopSetting(int[0:6],"Role","Tank Player",2,0)
globalvar respawn_counter

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


rule "[hero_switch.opy]: No Assemble Heroes":
    @Condition isAssemblingHeroes() == true

    # Go to the end of the assembling heroes
    setMatchTime(0)
    # Wait a little to hero to spawn
    wait()
    # Pause match time to wait for the heroes to be chosen
    pauseMatchTime()
    # 30 seconds to choose your character and make every hero respawn to be in their spawn and start the match
    respawn_counter = 0
    while respawn_counter < 5 :
        wait(5)
        respawn_character = true
        wait()
        respawn_character = false
        respawn_counter+=1
        
    unpauseMatchTime()
    

rule "[hero_switch.opy]: Respawn hero to start the match":
    @Event eachPlayer
    @Condition respawn_character == true
    
    eventPlayer.respawn()

    
rule "[hero_switch.opy]: Role limit lockout damage":
    @Event eachPlayer
    @Condition eventPlayer.role_lock != true
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_damage]) >= role_limit_damage

    if eventPlayer.getCurrentHero() in hero_list_damage :
        eventPlayer.setAllowedHeroes(hero_list_damage)
        eventPlayer.role_lock = true
    else :
        eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_damage))

rule "[hero_switch.opy]: Role limit lockout support":
    @Event eachPlayer
    @Condition eventPlayer.role_lock != true
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_support]) >= role_limit_support

    if eventPlayer.getCurrentHero() in hero_list_support :
        eventPlayer.setAllowedHeroes(hero_list_support)
        eventPlayer.role_lock = true
    else :
        eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_support))

rule "[hero_switch.opy]: Role limit lockout tank":
    @Event eachPlayer
    @Condition eventPlayer.role_lock != true
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in hero_list_tank]) >= role_limit_tank

    if eventPlayer.getCurrentHero() in hero_list_tank :
        eventPlayer.setAllowedHeroes(hero_list_tank)
        eventPlayer.role_lock = true
    else :
        eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(hero_list_tank))

