#!mainFile "../../dev_main.opy"

#!define OW1_WRECKING_BALL_GRAPPLE_COOLDOWN 5

rule "[wreckingball/grapple.opy]: OW1 Grappling Claw Cooldown":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.HAMMOND
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, OW1_WRECKING_BALL_GRAPPLE_COOLDOWN)


rule "[wreckingball/grapple.opy]: Correct Fireball impact damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.HAMMOND
    @Condition eventAbility == Button.SECONDARY_FIRE
        
        damage(
            victim, 
            attacker, 
            ((OW1_WRECKING_BALL_FIREBALL_DAMAGE/OW2_WRECKING_BALL_FIREBALL_DAMAGE) \
            * (eventDamage/eventPlayer._base_damage_scalar) \
            - eventDamage)/eventPlayer._base_damage_scalar)
