#!mainFile "../../main.opy"

playervar flashbang_pvar
#!defineMember _is_using_flashbang flashbang_pvar[0]


rule "[cassidy/flashbang.opy]: OW1 flashbang":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2

    eventPlayer._is_using_flashbang = false
    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_CASSIDY_FLASHBANG_STUN_DURATION)
    victim.setMoveSpeed(percent(1/OW2_CASSIDY_FLASHBANG_SPEED_REDUCTION))
    wait(OW2_CASSIDY_FLASHBANG_HINDER_DURATION)
    victim.setMoveSpeed(100)
