#!mainFile "../main.opy"

playervar hero_switch_pvar
#!defineMember _last_hero_played hero_switch_pvar[0]
#!defineMember _hero_switched hero_switch_pvar[1]
#!defineMember _hero_id hero_switch_pvar[2]


rule "[hero_switch.opy]: detect hero switch":
    @Event eachPlayer
    @Condition updateEveryTick(eventPlayer._last_hero_played != eventPlayer.getCurrentHero())
    
    eventPlayer._hero_switched = true
    wait()
    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._hero_id = heroID(eventPlayer._last_hero_played)
    eventPlayer._hero_switched = false
