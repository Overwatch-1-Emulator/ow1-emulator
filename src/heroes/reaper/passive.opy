#!mainFile "../../dev_main.opy"


rule "[reaper/init.opy]: Reaper Passive":
    @Event playerDealtDamage
    @Hero reaper

    heal(eventPlayer, null, eventDamage * OW1_REAPER_LIFESTEAL)
