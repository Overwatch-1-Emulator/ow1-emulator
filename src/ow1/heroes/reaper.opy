#!mainFile "../../main.opy"

subroutine initReaper

rule "[reaper.opy]: Detect Reaper initialization":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initReaper()
    eventPlayer.call_init = false


def initReaper():
    @Name "[reaper.opy]: initReaper()"
    # [TODO]
    pass


rule "[reaper.opy]: Deal OW1 Reaper primary fire damage":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_REAPER_HELLFIRE_SHOTGUNS_DAMAGE/OW2_REAPER_HELLFIRE_SHOTGUNS_DAMAGE)-eventDamage)
