#!mainFile "../../dev_main.opy"


rule "[pharah/concussive.opy]: Remove OW2 Concussive Blast damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.PHARAH
    @Condition eventAbility == Button.ABILITY_2

    heal(victim, null, eventDamage)
