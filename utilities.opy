#Useful function macros
#!define heroID(h) getAllHeroes().index(h)

#Player variables
playervar last_hero_played
playervar hero_switched


rule "detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.last_hero_played != eventPlayer.getCurrentHero()
    
    eventPlayer.hero_switched = true
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    wait()
    eventPlayer.hero_switched = false