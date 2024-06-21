#!mainFile "../../dev_main.opy"

playervar flashbang_pvar
#!defineMember _is_using_flashbang flashbang_pvar[0]


rule "[mccree/flashbang.opy]: OW1 flashbang":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventAbility == Button.ABILITY_2

    eventPlayer._is_using_flashbang = false
    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_MCCREE_FLASHBANG_STUN_DURATION)
    heal(victim, null, OW2_MCCREE_FLASHBANG_DAMAGE - OW1_MCCREE_FLASHBANG_DAMAGE)
    victim.setMoveSpeed(percent(1/OW2_MCCREE_FLASHBANG_SPEED_REDUCTION))
    wait(OW2_MCCREE_FLASHBANG_HINDER_DURATION)
    victim.setMoveSpeed(100)
