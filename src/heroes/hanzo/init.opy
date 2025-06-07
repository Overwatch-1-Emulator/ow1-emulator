#!mainFile "../../dev_main.opy"

#!include "storm.opy"


def initHanzo():
    @Name "[hanzo/init.opy]: initHanzo()"
    
    setCustomHp(OW1_HANZO_HEALTH, 0, 0)
    setUltCost(OW1_HANZO_ULT_COST)
    removeSelfHealing()


rule "[hanzo/init.opy]: Deal OW1 primary fire damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1]

    damage(victim, attacker, eventDamage*(OW1_HANZO_ARROW_DAMAGE/OW2_HANZO_ARROW_DAMAGE)-eventDamage)
