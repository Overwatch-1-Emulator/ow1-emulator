#!mainFile "../../main.opy"


rule "[pharah/concussive.opy]: Remove OW2 Concussive Blast damage":
    @Event playerDealtDamage
    @Hero pharah
    @Condition eventAbility == Button.ABILITY_2

    heal(victim, null, eventDamage)
