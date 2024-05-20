#!mainFile "../../dev_main.opy"

#!include "heroes/baptiste/regen_burst.opy"


rule "[baptiste/init.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer._call_init == true

    setCustomHp(OW1_BAPTISTE_HEALTH, 0, 0)
    setUltCost(OW1_BAPTISTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BAPTISTE_PRIMARY_DAMAGE/OW2_BAPTISTE_PRIMARY_DAMAGE)

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

    removeSelfHealing()

    eventPlayer._call_init = false
