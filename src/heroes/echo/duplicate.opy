#!mainFile "../../dev_main.opy"

globalvar health_pool

playervar hero_id_duplicated


rule "[echo/duplicate.opy]: Table of all heroes with custom hp":
    # tanks
    health_pool[heroID(Hero.DVA)] = [OW1_DVA_HEALTH,OW1_DVA_ARMOR,0]
    health_pool[heroID(Hero.HAMMOND)] = [OW1_WRECKING_BALL_HEALTH,OW1_WRECKING_BALL_ARMOR,0]
    health_pool[heroID(Hero.JUNKER_QUEEN)] = [OW1_JUNKERQUEEN_HEALTH,OW1_JUNKERQUEEN_ARMOR,0]
    health_pool[heroID(Hero.MAUGA)] = [OW1_MAUGA_HEALTH,OW1_MAUGA_ARMOR,0]
    health_pool[heroID(Hero.ORISA)] = [OW1_ORISA_HEALTH,OW1_ORISA_ARMOR,0]
    health_pool[heroID(Hero.RAMATTRA)] = [OW1_RAMATTRA_HEALTH,0,OW1_RAMATTRA_SHIELDS]
    health_pool[heroID(Hero.REINHARDT)] = [OW1_REINHARDT_HEALTH,OW1_REINHARDT_ARMOR,0]
    health_pool[heroID(Hero.ROADHOG)] = [OW1_ROADHOG_HEALTH,0,0]
    health_pool[heroID(Hero.SIGMA)] = [OW1_SIGMA_HEALTH,0,OW1_SIGMA_SHIELDS]
    health_pool[heroID(Hero.WINSTON)] = [OW1_WINSTON_HEALTH,OW1_WINSTON_ARMOR,0]
    health_pool[heroID(Hero.ZARYA)] = [OW1_ZARYA_HEALTH,0,OW1_ZARYA_SHIELDS]

    # dps
    health_pool[heroID(Hero.ASHE)] = [OW1_ASHE_HEALTH,0,0]
    health_pool[heroID(Hero.BASTION)] = [OW1_BASTION_HEALTH,OW1_BASTION_ARMOR,0]
    health_pool[heroID(Hero.MCCREE)] = [OW1_MCCREE_HEALTH,0,0]
    health_pool[heroID(Hero.DOOMFIST)] = [OW1_DOOMFIST_HEALTH,0,0]
    health_pool[heroID(Hero.GENJI)] = [OW1_GENJI_HEALTH,0,0]
    health_pool[heroID(Hero.HANZO)] = [OW1_HANZO_HEALTH,0,0]
    health_pool[heroID(Hero.JUNKRAT)] = [OW1_JUNKRAT_HEALTH,0,0]
    health_pool[heroID(Hero.MEI)] = [OW1_MEI_HEALTH,0,0]
    health_pool[heroID(Hero.PHARAH)] = [OW1_PHARAH_HEALTH,0,0]
    health_pool[heroID(Hero.REAPER)] = [OW1_REAPER_HEALTH,0,0]
    health_pool[heroID(Hero.SOLDIER)] = [OW1_SOLDIER_HEALTH,0,0]
    health_pool[heroID(Hero.SOJOURN)] = [OW1_SOJOURN_HEALTH,0,0]
    health_pool[heroID(Hero.SOMBRA)] = [OW1_SOMBRA_HEALTH,0,0]
    health_pool[heroID(Hero.SYMMETRA)] = [OW1_SYMMETRA_HEALTH,0,OW1_SYMMETRA_SHIELDS]
    health_pool[heroID(Hero.TORBJORN)] = [OW1_TORBJORN_HEALTH,OW1_TORBJORN_ARMOR,0]
    health_pool[heroID(Hero.TRACER)] = [OW1_TRACER_HEALTH,0,0]
    health_pool[heroID(Hero.WIDOWMAKER)] = [OW1_WIDOWMAKER_HEALTH,0,0]

    # supports
    health_pool[heroID(Hero.ANA)] = [OW1_ANA_HEALTH,0,0]
    health_pool[heroID(Hero.BAPTISTE)] = [OW1_BAPTISTE_HEALTH,0,0]
    health_pool[heroID(Hero.BRIGITTE)] = [OW1_BRIGITTE_HEALTH,OW1_BRIGITTE_ARMOR,0]
    health_pool[heroID(Hero.ILLARI)] = [OW1_ILLARI_HEALTH,0,0]
    health_pool[heroID(Hero.KIRIKO)] = [OW1_KIRIKO_HEALTH,0,0]
    health_pool[heroID(Hero.LIFEWEAVER)] = [OW1_LIFEWEAVER_HEALTH,0,0]
    health_pool[heroID(Hero.LUCIO)] = [OW1_LUCIO_HEALTH,0,0]
    health_pool[heroID(Hero.MERCY)] = [OW1_MERCY_HEALTH,0,0]
    health_pool[heroID(Hero.MOIRA)] = [OW1_MOIRA_HEALTH,0,0]
    health_pool[heroID(Hero.ZENYATTA)] = [OW1_ZENYATTA_HEALTH,0,OW1_ZENYATTA_SHIELDS]


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
