#!mainFile "../main.opy"

playervar hero_switch_pvar
#!defineMember last_hero_played hero_switch_pvar[0]
#!defineMember hero_switched hero_switch_pvar[1]
#!defineMember hero_id hero_switch_pvar[2]


rule "[hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition updateEveryTick(eventPlayer.last_hero_played != eventPlayer.getCurrentHero())
    
    eventPlayer.hero_switched = true
    wait()
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer.hero_id = heroID(eventPlayer.last_hero_played)
    eventPlayer.hero_switched = false


rule "[utilities/hero_switch.opy]: Detect switch to Ana":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Ashe":
    @Event eachPlayer
    @Hero ashe

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Baptiste":
    @Event eachPlayer
    @Hero baptiste

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Bastion":
    @Event eachPlayer
    @Hero bastion

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Brigitte":
    @Event eachPlayer
    @Hero brigitte

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Doomfist":
    @Event eachPlayer
    @Hero doomfist

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Dva":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.hero_switched
    # Apparently Pilot DVa and Mech DVA are 2 seperate heroes but workshop considers them both dva
    # Above condition is needed because otherwise, this rule activates every time dva transitions from pilot to mech and vice versa

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Echo":
    @Event eachPlayer
    @Hero echo

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Genji":
    @Event eachPlayer
    @Hero genji

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Hero hanzo

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Illari":
    @Event eachPlayer
    @Hero illari

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to JunkerQueen":
    @Event eachPlayer
    @Hero junkerQueen

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Junkrat":
    @Event eachPlayer
    @Hero junkrat

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Kiriko":
    @Event eachPlayer
    @Hero kiriko

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Lucio":
    @Event eachPlayer
    @Hero lucio

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Mccree":
    @Event eachPlayer
    @Hero mccree

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Mei":
    @Event eachPlayer
    @Hero mei

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Mercy":
    @Event eachPlayer
    @Hero mercy

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Moira":
    @Event eachPlayer
    @Hero moira

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Orisa":
    @Event eachPlayer
    @Hero orisa

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Hero pharah

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Ramattra":
    @Event eachPlayer
    @Hero ramattra

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Reaper":
    @Event eachPlayer
    @Hero reaper

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Reinhardt":
    @Event eachPlayer
    @Hero reinhardt

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Roadhog":
    @Event eachPlayer
    @Hero roadhog

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Sigma":
    @Event eachPlayer
    @Hero sigma

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Sojourn":
    @Event eachPlayer
    @Hero sojourn

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Soldier":
    @Event eachPlayer
    @Hero soldier

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Sombra":
    @Event eachPlayer
    @Hero sombra

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Symmetra":
    @Event eachPlayer
    @Hero symmetra

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Torbjorn":
    @Event eachPlayer
    @Hero torbjorn

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Tracer":
    @Event eachPlayer
    @Hero tracer

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Widowmaker":
    @Event eachPlayer
    @Hero widowmaker

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Hero winston

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Hammond":
    @Event eachPlayer
    @Hero hammond

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Zarya":
    @Event eachPlayer
    @Hero zarya

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Zenyatta":
    @Event eachPlayer
    @Hero zenyatta

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Detect switch to Widowmaker":
    @Event eachPlayer
    @Hero widowmaker

    eventPlayer.call_init = true
