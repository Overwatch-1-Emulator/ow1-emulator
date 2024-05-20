#!mainFile "../../dev_main.opy"


rule "[reaper/blossom.opy]: OW1 Death Blossom damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.REAPER
    @Condition eventAbility == Button.ULTIMATE

    heal(victim, null, eventDamage - (OW1_REAPER_DEATH_BLOSSON_DAMAGE/OW2_REAPER_DEATH_BLOSSON_DAMAGE) * eventDamage)
