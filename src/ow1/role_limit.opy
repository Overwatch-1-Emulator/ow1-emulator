#!mainFile "../main.opy"

#Global variables

globalvar HeroListDamage 0
globalvar HeroListTank 1
globalvar HeroListSupport 2
globalvar RoleLimitDamage 3
globalvar RoleLimitTank 4
globalvar RoleLimitSupport 5

rule "[role_limit.opy]: Remove OW2 heroes and change Doomfist to DPS":
    HeroListDamage = getDamageHeroes()
    HeroListDamage.append([Hero.DOOMFIST])
    HeroListDamage.remove([Hero.SOJOURN])
    HeroListTank = getTankHeroes()
    HeroListTank.remove([Hero.DOOMFIST,Hero.JUNKER_QUEEN,Hero.RAMATTRA])
    HeroListSupport = getSupportHeroes()
    HeroListSupport.remove([Hero.KIRIKO,Hero.LIFEWEAVER])
    RoleLimitDamage = 2
    RoleLimitTank = 2
    RoleLimitSupport = 2


rule "[role_limit.opy]: Role limit lockout damage":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in HeroListDamage]) >= RoleLimitDamage
    @Condition eventPlayer.getCurrentHero() in HeroListDamage == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(HeroListDamage))


rule "[role_limit.opy]: Role limit enable damage":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in HeroListDamage]) < RoleLimitDamage
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(HeroListDamage))


rule "[role_limit.opy]: Role limit lockout tank":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in HeroListTank]) >= RoleLimitTank
    @Condition eventPlayer.getCurrentHero() in HeroListTank == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(HeroListTank))


rule "[role_limit.opy]: Role limit enable tank":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in HeroListTank]) < RoleLimitTank
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(HeroListTank))


rule "[role_limit.opy]: Role limit lockout support":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in HeroListSupport]) >= RoleLimitSupport
    @Condition eventPlayer.getCurrentHero() in HeroListSupport == false
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().exclude(HeroListSupport))


rule "[role_limit.opy]: Role limit enable support":
    @Event eachPlayer
    @Condition len([player for player in getPlayers(eventPlayer.getTeam()) if player.getCurrentHero() in HeroListSupport]) < RoleLimitSupport
    
    eventPlayer.setAllowedHeroes(eventPlayer.getAllowedHeroes().concat(HeroListSupport))


