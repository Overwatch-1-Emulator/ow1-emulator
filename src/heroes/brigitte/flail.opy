#!mainFile "../../dev_main.opy"



rule "Rule 1":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventPlayer.isFiringSecondaryFire()
    
    damage(victim, eventPlayer, 445)
