# Macro function for retrieving id of hero
#!define heroID(h) getAllHeroes().index(h)

# Macro function for converting decimal to percent
#!define percent(p) 100*p

# Macro function for converting decimal to percent
#!define roundedPercent(p) round(100*p)

# Macro function for converting decimal to percent
#!define percentOf(p, n) p/100*n

#Useful function macros
#!define heroID(h) getAllHeroes().index(h)

#Player variables
playervar last_hero_played
playervar hero_switched
playervar hero_id

rule "detect hero switch":
    @Event eachPlayer
    @Condition eventPlayer.last_hero_played != eventPlayer.getCurrentHero()
    
    eventPlayer.hero_switched = true
    eventPlayer.last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer.hero_id = heroID(eventPlayer.last_hero_played)
    wait()
    eventPlayer.hero_switched = false
