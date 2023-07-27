#!mainFile "../../main.opy"

subroutine initBaptiste

rule "[baptiste.opy]: Detect Baptiste initialization":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initBaptiste()
    eventPlayer.initialized = true


def initBaptiste():
    @Name "[baptiste.opy]: initBaptiste()"
    
    eventPlayer.setAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_BAPTISTE_CLIP1_SIZE)

    eventPlayer.setAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)
    eventPlayer.setMaxAmmo(1, OW1_BAPTISTE_CLIP2_SIZE)

    removeSelfHealing()


rule "[baptiste.opy]: Set default immortality field cooldown":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility2()
    
    waitUntil(not eventPlayer.isUsingAbility2(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_BAPTISTE_IMMORTALITY_FIELD_COOLDOWN_TIME)


rule "[baptiste.opy]: Allow self healing during Biotic Orb":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.self_healing_percent = 100
    wait(OW1_BAPTISTE_REGEN_BURST_DURATION)
    # waitUntil(eventPlayer.isUsingAbility1() == false, 9999)
    eventPlayer.self_healing_percent = 0
