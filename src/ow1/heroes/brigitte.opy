#!mainFile "../../main.opy"
# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

def initBrigitte():
    
    do:
        clearCustomHealth()
        setCustomHealth(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_BRIGITTE_HEALTH + OW1_BRIGITTE_ARMOR)


rule "[brigitte.opy]: Initialize Brigitte":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initBrigitte()


rule "[brigitte.opy]: Add stun to shield bash":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, ow1_shield_bash_stun_duration)


rule "[brigitte.opy]: Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setMoveSpeed(77.8) # arbitrarily decided based on trial and error
    waitUntil(not eventPlayer.isFiringPrimaryFire(), 1)
    if eventPlayer.isUsingUltimate():
        eventPlayer.setMoveSpeed(percent(ow1_rally_speed_buff/ow2_rally_speed_buff))
    else:
        eventPlayer.setMoveSpeed(100)


rule "[brigitte.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(percent(ow1_rally_speed_buff/ow2_rally_speed_buff)) # 30% movement speed buff during ralley
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setMoveSpeed(100)
