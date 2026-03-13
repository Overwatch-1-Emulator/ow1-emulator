#!mainFile "../../dev_main.opy"


rule "[hanzo/storm.opy]: OW1 storm arrow damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility == Button.ABILITY_2

    heal(victim, null, eventDamage - eventDamage*(OW1_HANZO_STORM_DAMAGE/OW2_HANZO_STORM_DAMAGE))
