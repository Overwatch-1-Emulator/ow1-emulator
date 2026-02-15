#!mainFile "../../dev_main.opy"

#!include "blossom.opy"
#!include "passive.opy"
#!include "shadowstep.opy"

def initReaper():
    @Name "[reaper/init.opy]: initReaper()"

    setCustomHp(OW1_REAPER_HEALTH, 0, 0)
    setUltCost(OW1_REAPER_ULT_COST)
    #removePassiveHealing()


rule "[reaper/init.opy]: Deal OW1 Reaper primary fire damage":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (OW1_REAPER_HELLFIRE_SHOTGUNS_DAMAGE/OW2_REAPER_HELLFIRE_SHOTGUNS_DAMAGE) * eventDamage - eventDamage)
