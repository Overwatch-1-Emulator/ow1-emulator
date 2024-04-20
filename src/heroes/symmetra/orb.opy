#!mainFile "../../main.opy"


rule "[symmetra/orb.opy]: Set OW1 Symmetra Photo Projector projectile speed":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setProjectileSpeed(percent(OW1_SYMMETRA_ORB_SPEED/OW2_SYMMETRA_ORB_SPEED))
    waitUntil(not eventPlayer.isFiringSecondaryFire(), Math.INFINITY)
    eventPlayer.setProjectileSpeed(100)


rule "[symmetra/orb.opy]: Deal OW1 symmetra secondary fire damage":
    @Event playerDealtDamage
    @Hero symmetra
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(
        victim, 
        attacker, 
        ((OW1_SYMMETRA_ORB_DAMAGE/OW2_SYMMETRA_ORB_DAMAGE) \
        * (eventDamage/eventPlayer._base_damage_scalar) \
        - eventDamage)/eventPlayer._base_damage_scalar)
