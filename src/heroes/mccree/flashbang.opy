#!mainFile "../../main.opy"



rule "[mccree/flashbang.opy]: OW1 flashbang":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2

    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_MCCREE_FLASHBANG_STUN_DURATION)
    victim.setMoveSpeed(percent(1/OW2_MCCREE_FLASHBANG_SPEED_REDUCTION))
    wait(OW2_MCCREE_FLASHBANG_HINDER_DURATION)
    victim.setMoveSpeed(100)

rule "[mccree/flashbang.opy]: OW1 flashbang damage":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0

    eventPlayer.setDamageDealt(percent(OW1_MCCREE_FLASHBANG_DAMAGE/OW2_MCCREE_FLASHBANG_DAMAGE))
    wait(OW2_MCCREE_FLASHBANG_DAMAGE_INTERVAL)
    eventPlayer.setDamageDealt(percent(eventPlayer._base_damage_scalar))
