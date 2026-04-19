#!mainFile "../../main.opy"

#!include "blossom.opy"
#!include "passive.opy"
#!include "shadowstep.opy"

def initReaper():
    @Name "[reaper/init.opy]: initReaper()"

    setCustomHp(OW1_REAPER_HEALTH, 0, 0)
    setUltCost(OW1_REAPER_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE)

    eventPlayer.disallowButton(Button.SECONDARY_FIRE)


rule "[reaper/init.opy]: Deal OW1 Reaper primary fire damage":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_REAPER_HELLFIRE_SHOTGUNS_DAMAGE/OW2_REAPER_HELLFIRE_SHOTGUNS_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
