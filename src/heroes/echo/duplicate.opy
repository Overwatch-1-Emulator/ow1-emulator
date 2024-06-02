#!mainFile "../../dev_main.opy"


rule "[echo/duplicate.opy]: Reset and call init on duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero()
    
    eventPlayer._hero_setup = eventPlayer.getHeroOfDuplication()
    resetHero()
    eventPlayer._call_init = true
    waitUntil(not eventPlayer._call_init, Math.INFINITY)
    enableAllAbilities()


rule "[echo/duplicate.opy]: Initialize Duplicate Echo":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer._call_init
    @Condition eventPlayer.isDuplicatingAHero()

    switch eventPlayer.getHeroOfDuplication():
        case Hero.ANA:
            initAna()
            break
        case Hero.ASHE:
            initAshe()
            break
        case Hero.BAPTISTE:
            initBaptiste()
            break
        case Hero.BASTION:
            initBastion()
            break
        case Hero.BRIGITTE:
            initBrigitte()
            break
        case Hero.DOOMFIST:
            initDoomfist()
            break
        case Hero.DVA:
            initDva()
            break
        case Hero.ECHO:
            initEcho()
            break
        case Hero.GENJI:
            initGenji()
            break
        case Hero.HANZO:
            initHanzo()
            break
        case Hero.ILLARI:
            initIllari()
            break
        case Hero.JUNKER_QUEEN:
            initJunkerQueen()
            break
        case Hero.JUNKRAT:
            initJunkrat()
            break
        case Hero.KIRIKO:
            initKiriko()
            break
        case Hero.LIFEWEAVER:
            initLifeweaver()
            break
        case Hero.LUCIO:
            initLucio()
            break
        case Hero.MAUGA:
            initMauga()
            break
        case Hero.MCCREE:
            initMccree()
            break
        case Hero.MEI:
            initMei()
            break
        case Hero.MERCY:
            initMercy()
            break
        case Hero.MOIRA:
            initMoira()
            break
        case Hero.ORISA:
            initOrisa()
            break
        case Hero.PHARAH:
            initPharah()
            break
        case Hero.RAMATTRA:
            initRamattra()
            break
        case Hero.REAPER:
            initReaper()
            break
        case Hero.REINHARDT:
            initReinhardt()
            break
        case Hero.ROADHOG:
            initRoadhog()
            break
        case Hero.SIGMA:
            initSigma()
            break
        case Hero.SOJOURN:
            initSojourn()
            break
        case Hero.SOLDIER:
            initSoldier()
            break
        case Hero.SOMBRA:
            initSombra()
            break
        case Hero.SYMMETRA:
            initSymmetra()
            break
        case Hero.TORBJORN:
            initTorbjorn()
            break
        case Hero.TRACER:
            initTracer()
            break
        case Hero.VENTURE:
            initVenture()
            break
        case Hero.WIDOWMAKER:
            initWidowmaker()
            break
        case Hero.WINSTON:
            initWinston()
            break
        case Hero.HAMMOND:
            initHammond()
            break
        case Hero.ZARYA:
            initZarya()
            break
        case Hero.ZENYATTA:
            initZenyatta()
            break
        default:
            break

    resetSelfHealing()
    removePassiveHealing()
    eventPlayer._call_init = false


rule "[echo/duplicate.opy]: Reinitialize echo after exiting duplicate":
    @Event eachPlayer
    @Hero echo
    @Condition not eventPlayer.isDuplicatingAHero()

    eventPlayer._hero_setup = eventPlayer.getCurrentHero()
    resetHero()
    eventPlayer._call_init = true


rule "[echo/duplicate.opy]: Correct duplicate ultimate charge rate":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isDuplicatingAHero()
    @Condition eventPlayer.getUltCharge() == 0

    wait()
    eventPlayer.setUltCharge((percent(1 - (OW2_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER/OW1_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER)))/OW2_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER)
