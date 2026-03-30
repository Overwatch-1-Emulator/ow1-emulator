#!mainFile "../../main.opy"


rule "[reaper/init.opy]: Reaper Passive":
    @Event playerDealtDamage
    @Hero reaper

    heal(eventPlayer, null, eventDamage * 0.055) #todo fix shoudl be fixed I dont know if it scales with the damage rule in there as well
