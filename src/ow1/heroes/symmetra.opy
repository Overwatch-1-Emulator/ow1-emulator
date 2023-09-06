#!mainFile "../../main.opy"

rule "[symmetra.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization
    
    eventPlayer.setAmmo(0, OW1_SYMMETRA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_SYMMETRA_CLIP_SIZE)


rule "[symmetra.opy]: Set OW1 Symmetra Photo Projector projectile speed":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setProjectileSpeed(percent(OW1_SYMMETRA_ORB_SPEED/OW2_SYMMETRA_ORB_SPEED))
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, Math.INFINITY)
    eventPlayer.setProjectileSpeed(100)
