#!mainFile "../../main.opy"

playervar swift_step_pvar
#!defineMember _hp_before_step swift_step_pvar[0]


rule "[kiriko/swift_step.opy]: Heal when using Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer._hp_before_step = eventPlayer.getHealth()
    heal(eventPlayer, eventPlayer, OW1_KIRIKO_SWIFT_STEP_HEALING)
    eventPlayer._missing_ult_points += eventPlayer.getHealth()-eventPlayer._hp_before_step
