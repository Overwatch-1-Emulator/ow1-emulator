#!mainFile "../../dev_main.opy"


rule "[soldier/pulse_rifle.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE)-eventDamage)


rule "[soldier/pulse_rifle.opy]: Deal OW1 soldier primary fire damage":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.getAmmo(0) < eventPlayer.getMaxAmmo(0)

    do:
        wait(1/6)
        eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
    while RULE_CONDITION
