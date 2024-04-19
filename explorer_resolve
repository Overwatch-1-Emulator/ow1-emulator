#!include "env/dev_env.opy"

rule "[venture/explorer_resolve.opy]: remove explore resolve passive":
    @Hero venture
    @Event eachPlayer
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) == true
    
    damage(eventPlayer, null, eventPlayer.getHealthOfType(Health.SHIELDS))
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START

  # use for ow1++ or dont, just use it if you liked to remove it.
