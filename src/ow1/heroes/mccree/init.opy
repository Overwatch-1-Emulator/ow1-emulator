#!mainFile "../../../main.opy"

#!include "ow1/heroes/mccree/flashbang.opy"
#!include "ow1/heroes/mccree/roll.opy"
#!include "ow1/heroes/mccree/deadeye.opy"

rule "[mccree/init.opy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer.call_init

    eventPlayer.setAbility2Enabled(false) # Prevents throwing magnetic grenade
    resetStats()
    resetStatuses()
    resetFrenemies()
    resetUltCharge()
    clearCustomHealth()
    resetSelfHealing()
    setCustomHealth(OW1_MCCREE_HEALTH, 0, 0)
    resetAbilities()
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.call_init = false
