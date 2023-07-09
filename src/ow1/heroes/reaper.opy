#!mainFile "../../main.opy"

subroutine initReaper

rule "[reaper.opy]: Initialize Reaper":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initReaper()
    eventPlayer.initialized = true


def initReaper():
    @Name "[reaper.opy]: initReaper()"
    # [TODO]
    pass