#!mainFile "../../main.opy"

subroutine initLucio

rule "[lucio.opy]: Detect Lucio initialization":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initLucio()
    eventPlayer.initialized = true


def initLucio():
    @Name "[lucio.opy]: initLucio()"
    startHealingModification(eventPlayer, eventPlayer, percent(OW1_LUCIO_SELF_HEALING/OW2_LUCIO_SELF_HEALING), HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.healing_modification = getLastHealingModification()


rule "[lucio.opy]: Revert Lucio self healing when using amp":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2()

    stopHealingModification(eventPlayer.healing_modification)
    waitUntil(not eventPlayer.isUsingAbility2(), 99999)
    startHealingModification(eventPlayer, eventPlayer, percent(OW1_LUCIO_SELF_HEALING/OW2_LUCIO_SELF_HEALING), HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.healing_modification = getLastHealingModification()
