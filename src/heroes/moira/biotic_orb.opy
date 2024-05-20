#!mainFile "../../dev_main.opy"


# rule "[moira/biotic_orb.opy]: Allow self healing during Biotic Orb":
#     @Event eachPlayer
#     @Condition eventPlayer._hero_setup == Hero.MOIRA
#     @Condition eventPlayer.isUsingAbility2()
#     @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

#     pushSelfHealing(Button.ABILITY_2)
#     wait(7, Wait.IGNORE_CONDITION)
#     popSelfHealing(Button.ABILITY_2)
