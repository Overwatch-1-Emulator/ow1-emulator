#!mainFile "../../main.opy"

subroutine initSymmetra

rule "[symmetra.opy]: Detect Symmetra initialization":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSymmetra()
    eventPlayer.initialized = true


def initSymmetra():
    @Name "[symmetra.opy]: initSymmetra()"
    eventPlayer.setAmmo(0, OW1_SYMMETRA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_SYMMETRA_CLIP_SIZE)


rule "[symmetra.opy]: Set OW1 Symmetra Photo Projector projectile speed":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.isFiringSecondaryFire()

    eventPlayer.setProjectileSpeed(percent(OW1_SYMMETRA_ORB_SPEED/OW2_SYMMETRA_ORB_SPEED))
    waitUntil(eventPlayer.isFiringSecondaryFire() == false, 9999)
    eventPlayer.setProjectileSpeed(100)
