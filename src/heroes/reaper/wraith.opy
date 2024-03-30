#!mainFile "../../dev_main.opy"


rule "[reaper/wraith.opy]: Float during wraith":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.setGravity(0)
    waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    eventPlayer.setGravity(100)


rule "[reaper/wraith.opy]: Move upwards on jump during wraith":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    do:
        eventPlayer.applyImpulse(Vector.UP, FLIGHT_IMPULSE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION


rule "[reaper/wraith.opy]: Move upwards on crouch during wraith":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    do:
        eventPlayer.applyImpulse(Vector.DOWN, FLIGHT_IMPULSE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    while RULE_CONDITION
