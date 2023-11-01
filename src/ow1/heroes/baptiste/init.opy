#!mainFile "../../../main.opy"

#!include "ow1/heroes/baptiste/regen_burst.opy"
#!include "ow1/heroes/baptiste/immort_field.opy"

rule "[baptiste/init.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.call_init == true

    
    resetHero()
    setCustomHealth(OW1_BAPTISTE_HEALTH, 0, 0)

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

    removeSelfHealing()

    eventPlayer.call_init = false
