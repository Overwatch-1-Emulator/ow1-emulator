#!mainFile "../../main.opy"

subroutine initBaptiste

def initBaptiste():
    @Name "[baptiste.opy]: initBaptiste()"
    
    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

rule "[baptiste.opy]: Initialize Baptiste":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initBaptiste()
    eventPlayer.initialized = true

rule "[baptiste.opy]: Set default immortality field cooldown":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_BAPTISTE_IMMORTALITY_FIELD_COOLDOWN_TIME)