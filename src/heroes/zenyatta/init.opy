#!mainFile "../../dev_main.opy"

#!include "transc.opy"

def initZenyatta():
    @Name "[zenyatta/init.opy]: initZenyatta()"
    
    setCustomHp(OW1_ZENYATTA_HEALTH, 0, OW1_ZENYATTA_SHIELDS)
    setUltCost(OW1_ZENYATTA_ULT_COST)
    removeSelfHealing()
    
    eventPlayer.setKnockbackDealt(percent(OW1_ZENYATTA_KNOCKBACK/OW2_ZENYATTA_KNOCKBACK))
    
    eventPlayer.setAmmo(0, OW1_ZENYATTA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ZENYATTA_CLIP_SIZE)





rule "[zenyatta/init.opy]: OW1 Zenyatta melee damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition eventAbility == null # for some reason, zenyatta melee doesn't show up as melee
    @Condition eventPlayer.isMeleeing()

    heal(victim, null, eventDamage - (OW1_MELEE_DAMAGE/OW2_ZENYATTA_MELEE_DAMAGE)*(eventDamage/eventPlayer._base_damage_scalar))
