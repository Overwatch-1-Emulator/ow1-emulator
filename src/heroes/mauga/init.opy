#!mainFile "../../../main.opy"


rule "[mauga/init.opy]: Initialize Mauga":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.call_init
    
    newHero(OW1_MAUGA_HEALTH, OW1_MAUGA_ARMOR, 0)
    removeTankPassive()
    
    eventPlayer.call_init = false
