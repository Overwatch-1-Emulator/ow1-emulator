#!mainFile "../../dev_main.opy"


rule "[mccree/fan_hammer.opy]: OW1 Fan the Hammer damage":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_MCCREE_FAN_THE_HAMMER_DAMAGE/OW2_MCCREE_FAN_THE_HAMMER_DAMAGE) - eventDamage)
