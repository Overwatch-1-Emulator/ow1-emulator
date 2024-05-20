#!mainFile "../../dev_main.opy"


rule "[reinhardt/shatter.opy]: OW1 one shot earthshatter":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.REINHARDT
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventWasCriticalHit
    
    damage(
        victim, 
        attacker, 
        ((eventDamage/eventPlayer._base_damage_scalar) * ((OW1_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW1_REINHARDT_EARTHSHATTER_BONUS_DAMAGE) 
            / (OW2_REINHARDT_EARTHSHATTER_BASE_DAMAGE + OW2_REINHARDT_EARTHSHATTER_BONUS_DAMAGE)) 
            - eventDamage)/eventPlayer._base_damage_scalar)


rule "[reinhardt/shatter.opy]: OW1 earthshatter knock down duration":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.REINHARDT
    @Condition victim.hasStatusEffect(Status.KNOCKED_DOWN)

    wait(OW1_REINHARDT_EARTHSHATTER_KNOCK_DOWN_DURATION)
    victim.clearStatusEffect(Status.KNOCKED_DOWN)
