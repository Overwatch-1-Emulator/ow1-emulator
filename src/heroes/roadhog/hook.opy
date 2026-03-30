#!mainFile "../../main.opy"

rule "[roadhog/hook.opy]: OW1 hook damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    damage(
        victim,
        attacker,
        6.82)  #todo fix this, the code that shoudl fix it is not working and idk why
