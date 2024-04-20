#!mainFile "../main.opy"

globalvar MaxRoles


/*
rule "Workshop Setting: Set Role Limits":
    MaxRoles = [createWorkshopSetting(int[0:5], "Role limits", "Tank Role Cap", 0, 0), createWorkshopSetting(int[0:5], "Role limits", "Damage Role Cap", 0, 1), createWorkshopSetting(int[0:5], "Role limits", "Support Role Cap", 0, 2)]
*/

/*
rule "Skip Hero Assembly Phase":
    @Condition isAssemblingHeroes() == true
    
    setMatchTime(0.1)
*/

/*
rule "Initialize Role Limits":
    @Event eachPlayer
    
    eventPlayer.allowed_heroes = getAllHeroes()
*/

/*
rule "Lock/Unlock Tank heroes at role limit":
    @Event eachPlayer
    @Condition len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getTankHeroes()]).exclude(eventPlayer)) >= MaxRoles[0]
    @Condition MaxRoles[0] > 0
    
    eventPlayer.allowed_heroes.remove(getTankHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
    waitUntil(len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getTankHeroes()]).exclude(eventPlayer)) < MaxRoles[0], 99999)
    eventPlayer.allowed_heroes.append(getTankHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
*/

/*
rule "Lock/Unlock Damage heroes at role limit":
    @Event eachPlayer
    @Condition len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getDamageHeroes()]).exclude(eventPlayer)) >= MaxRoles[1]
    @Condition MaxRoles[1] > 0
    
    eventPlayer.allowed_heroes.remove(getDamageHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
    waitUntil(len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getDamageHeroes()]).exclude(eventPlayer)) < MaxRoles[1], 99999)
    eventPlayer.allowed_heroes.append(getDamageHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
*/

/*
rule "Lock/Unlock Support heroes at role limit":
    @Event eachPlayer
    @Condition len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getSupportHeroes()]).exclude(eventPlayer)) >= MaxRoles[2]
    @Condition MaxRoles[2] > 0
    
    eventPlayer.allowed_heroes.remove(getSupportHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
    waitUntil(len(([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in getSupportHeroes()]).exclude(eventPlayer)) < MaxRoles[2], 99999)
    eventPlayer.allowed_heroes.append(getSupportHeroes())
    eventPlayer.setAllowedHeroes(eventPlayer.allowed_heroes)
*/
