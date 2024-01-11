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
