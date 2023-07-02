#!mainFile "../../main.opy"

def initMei():
    eventPlayer.setAmmo(0, OW1_MEI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MEI_CLIP_SIZE)

rule "[mei.opy]: Initialize Mei":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initMei()

rule "[mei.opy] Freeze enemy": # credit to snappycreeper for this rule
    @Event playerDealtDamage
    @Hero mei
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    wait(1.5, Wait.ABORT_WHEN_FALSE)
    victim.setStatusEffect(eventPlayer, Status.FROZEN, 1.5)
