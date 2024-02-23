#!mainFile "../../main.opy"

#!include "heroes/baptiste/regen_burst.opy"

rule "[baptiste/init.opy]: Detect switch to Baptiste":
    @Event eachPlayer
    @Hero baptiste

    eventPlayer.call_init = true


rule "[baptiste/init.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.call_init == true

    newHero(OW1_BAPTISTE_HEALTH, 0, 0)
    setUltCost(OW1_BAPTISTE_ULT_COST)

    setBaseDamage(eventPlayer, OW1_BAPTISTE_PRIMARY_DAMAGE/OW2_BAPTISTE_PRIMARY_DAMAGE)

    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

    removePassiveHealing()

    eventPlayer.call_init = false


rule "[baptiste/init.opy]: Correct all damage other than primary fire":
    @Event playerDealtDamage
    @Hero baptiste
    @Condition eventAbility not in [Button.PRIMARY_FIRE]

    damage(victim, attacker, eventDamage/eventPlayer._base_damage_scalar - eventDamage)
