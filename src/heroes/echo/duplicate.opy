#!mainFile "../../main.opy"

globalvar  health_pool

playervar hero_id_duplicated


rule "[echo/duplicate.opy]: Table of all heroes with custom hp":
    # tanks
    health_pool[heroID(Hero.DVA)] = [OW1_DVA_HEALTH,OW1_DVA_ARMOR,0]
    health_pool[heroID(Hero.HAMMOND)] = [OW1_WRECKING_BALL_HEALTH,OW1_WRECKING_BALL_ARMOR,0]
    health_pool[heroID(Hero.ORISA)] = [OW1_ORISA_HEALTH,OW1_ORISA_ARMOR,0]
    health_pool[heroID(Hero.REINHARDT)] = [OW1_REINHARDT_HEALTH,OW1_REINHARDT_ARMOR,0]
    health_pool[heroID(Hero.ROADHOG)] = [OW1_ROADHOG_HEALTH,0,0]
    health_pool[heroID(Hero.SIGMA)] = [OW1_SIGMA_HEALTH,0,OW1_SIGMA_SHIELDS]
    health_pool[heroID(Hero.WINSTON)] = [OW1_WINSTON_HEALTH,OW1_WINSTON_ARMOR,0]
    health_pool[heroID(Hero.ZARYA)] = [OW1_ZARYA_HEALTH,0,OW1_ZARYA_SHIELDS]

    # dps
    health_pool[heroID(Hero.DOOMFIST)] = [OW1_DOOMFIST_HEALTH,0,0]
    health_pool[heroID(Hero.ASHE)] = [OW1_ASHE_HEALTH,0,0]

    # supports
    health_pool[heroID(Hero.BAPTISTE)] = [OW1_BAPTISTE_HEALTH,0,0]


rule "[echo/duplicate.opy]: Set Life for echo when duplicating a tank":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero()
    
    clearCustomHp()
    eventPlayer.hero_id_duplicated = heroID(eventPlayer.getHeroOfDuplication())
    wait(1)
    setCustomHp(
        health_pool[eventPlayer.hero_id_duplicated][0],
        health_pool[eventPlayer.hero_id_duplicated][1],
        health_pool[eventPlayer.hero_id_duplicated][2],
    )
