#!mainFile "../main.opy"


playervar last_hero_played
playervar hero_switched
playervar hero_id

rule "[hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.last_hero_played != eventPlayer.getCurrentHero()
    
    eventPlayer.hero_switched = true
    wait()
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer.hero_id = heroID(eventPlayer.last_hero_played)
    eventPlayer.hero_switched = false


rule "[utilities/hero_switch.opy]: Ana init":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Ashe init":
    @Event eachPlayer
    @Hero ashe

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Baptiste init":
    @Event eachPlayer
    @Hero baptiste

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Bastion init":
    @Event eachPlayer
    @Hero bastion

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Brigitte init":
    @Event eachPlayer
    @Hero brigitte

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Doomfist init":
    @Event eachPlayer
    @Hero doomfist

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Dva init":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.hero_switched
    # Apparently Pilot DVa and Mech DVA are 2 seperate heroes but workshop considers them both dva
    # Above condition is needed because otherwise, this rule activates every time dva transitions from pilot to mech and vice versa

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Echo init":
    @Event eachPlayer
    @Hero echo

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Genji init":
    @Event eachPlayer
    @Hero genji

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Hanzo init":
    @Event eachPlayer
    @Hero hanzo

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Illari init":
    @Event eachPlayer
    @Hero illari

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: JunkerQueen init":
    @Event eachPlayer
    @Hero junkerQueen

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Junkrat init":
    @Event eachPlayer
    @Hero junkrat

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Kiriko init":
    @Event eachPlayer
    @Hero kiriko

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Lifeweaver init":
    @Event eachPlayer
    @Hero lifeweaver

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Lucio init":
    @Event eachPlayer
    @Hero lucio

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Mccree init":
    @Event eachPlayer
    @Hero mccree

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Mei init":
    @Event eachPlayer
    @Hero mei

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Mercy init":
    @Event eachPlayer
    @Hero mercy

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Moira init":
    @Event eachPlayer
    @Hero moira

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Orisa init":
    @Event eachPlayer
    @Hero orisa

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Pharah init":
    @Event eachPlayer
    @Hero pharah

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Ramattra init":
    @Event eachPlayer
    @Hero ramattra

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Reaper init":
    @Event eachPlayer
    @Hero reaper

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Reinhardt init":
    @Event eachPlayer
    @Hero reinhardt

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Roadhog init":
    @Event eachPlayer
    @Hero roadhog

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Sigma init":
    @Event eachPlayer
    @Hero sigma

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Sojourn init":
    @Event eachPlayer
    @Hero sojourn

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Soldier init":
    @Event eachPlayer
    @Hero soldier

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Sombra init":
    @Event eachPlayer
    @Hero sombra

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Symmetra init":
    @Event eachPlayer
    @Hero symmetra

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Torbjorn init":
    @Event eachPlayer
    @Hero torbjorn

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Tracer init":
    @Event eachPlayer
    @Hero tracer

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Widowmaker init":
    @Event eachPlayer
    @Hero widowmaker

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Winston init":
    @Event eachPlayer
    @Hero winston

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Hammond init":
    @Event eachPlayer
    @Hero hammond

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Zarya init":
    @Event eachPlayer
    @Hero zarya

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Zenyatta init":
    @Event eachPlayer
    @Hero zenyatta

    eventPlayer.call_init = true


rule "[utilities/hero_switch.opy]: Widowmaker init":
    @Event eachPlayer
    @Hero widowmaker

    eventPlayer.call_init = true
