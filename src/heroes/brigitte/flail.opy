#!mainFile "../../dev_main.opy"



rule "brigitte/flail.opy: OW1 flail damage":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventPlayer.isFiringSecondaryFire()

    damage(victim, attacker, 445)
