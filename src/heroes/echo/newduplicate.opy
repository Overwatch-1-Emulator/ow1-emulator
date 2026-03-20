#!mainFile "../../main.opy"
playervar echo_dupe
playervar echo_ult
playervar echo_text


def EchoCopyHud():
    eventPlayer.echo_ult = (OW1_ECHO_DUPLICATE_DURATION)
    chase(eventPlayer.echo_ult, 0, rate=1, ChaseReeval.NONE)
    createProgressBarInWorldText(eventPlayer, eventPlayer.echo_ult, "{0} {1}".format(abilityIconString(Hero.ECHO, Button.ULTIMATE), ceil(eventPlayer.echo_ult / 1)), updateEveryFrame(eventPlayer.getEyePosition() + (100 * (-1 * worldVector(Vector.RIGHT, eventPlayer, Transform.ROTATION) + (-0.25 * (directionFromAngles(horizontalAngleOfDirection(eventPlayer.getFacingDirection()), verticalAngleOfDirection(eventPlayer.getFacingDirection()) - 90))) + 3 * eventPlayer.getFacingDirection()))), 0.75)

rule "[echo/duplicate.opy]: Initialize duplicate hero":
    @Event eachPlayer
    #@Hero echo
    @Condition eventPlayer._hero_setup == Hero.ECHO
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    #@Condition eventPlayer.isDuplicatingAHero()

    #wait(0.016)
    eventPlayer._hero_setup = eventPlayer.getHeroOfDuplication()
    eventPlayer.echo_dupe = true
    EchoCopyHud()
    eventPlayer.startForcingHero(eventPlayer._hero_setup)


#rule "[echo/duplicate.opy]: Hero Duplicate ":
#    @Event eachPlayer
#    @Condition eventPlayer.echo_dupe == true
#    @Condition eventPlayer.getUltCharge() == 0
    #@Condition eventPlayer.getCurrentHero() not in [Hero.ECHO]

#    wait()
    #eventPlayer.setUltCharge((percent(1 - (OW2_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER/OW1_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER)))/OW2_ECHO_DUPLICATE_ULT_CHARGE_MULTIPLIER)

rule "[echo/duplicate.opy]: Reinitialize echo after exiting duplicate":
    @Event eachPlayer
    @Condition eventPlayer.echo_dupe
    #@Condition eventPlayer.getCurrentHero() not in [Hero.ECHO]

    waitUntil(eventPlayer.echo_ult <= 0)
    destroyAllProgressBarInWorldTexts()
    eventPlayer.startForcingHero(Hero.ECHO)
    eventPlayer.echo_dupe = false
    if eventPlayer.getHealth() <= 0.5:
        return
rule "[echo/duplicate.opy]: If Hero Dies during ech oult":
    @Event eachPlayer
    @Condition eventPlayer.echo_dupe == true
    @Condition eventPlayer.getHealth() <= 0.5

    eventPlayer.startForcingHero(Hero.ECHO)
    eventPlayer.setHealth(50)
    destroyAllProgressBarInWorldTexts()
    eventPlayer.echo_dupe = false

