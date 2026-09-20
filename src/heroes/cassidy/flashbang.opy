#!mainFile "../../main.opy"



rule "[cassidy/flashbang.opy]: OW1 flashbang":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2

    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_CASSIDY_FLASHBANG_STUN_DURATION)
    victim.setMoveSpeed(percent(1/OW2_CASSIDY_FLASHBANG_SPEED_REDUCTION))
    wait(OW2_CASSIDY_FLASHBANG_HINDER_DURATION)
    victim.setMoveSpeed(100)
