#!mainFile "../../main.opy"
# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

#!define distanceToPlayerObjects() distance(eventPlayer.getEyePosition(), raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition()+OW1_BRIGITTE_SHIELD_BASH_DISTANCE*getLateralFacingDirection(), getPlayers(getOppositeTeam(eventPlayer.getTeam())), null, true).getHitPosition())

def initBrigitte():
    
    do:
        clearCustomHealth()
        setCustomHealth(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_BRIGITTE_HEALTH + OW1_BRIGITTE_ARMOR)


rule "[brigitte.opy]: Initialize Brigitte":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initBrigitte()
    eventPlayer.initialized = true


rule "[brigitte.opy]: Add stun to shield bash":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, OW1_BRIGITTE_SHIELD_BASH_STUN_DURATION)


rule "[brigitte.opy]: Reduce shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setMoveSpeed(77.8) # arbitrarily decided based on trial and error
    waitUntil(not eventPlayer.isFiringPrimaryFire(), 1)
    if eventPlayer.isUsingUltimate():
        eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF))
    else:
        eventPlayer.setMoveSpeed(100)


rule "[brigitte.opy]: Prevent shield bashing through barrier":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true

    waitUntil(updateEveryTick(distanceToPlayerObjects() < OW1_BRIGITTE_SHIELD_TO_ENEMY_BARRIER_DISTANCE), 1)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), true) # immediately cancel momentum
    eventPlayer.cancelPrimaryAction()
    eventPlayer.stopForcingPosition()


rule "[brigitte.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setMoveSpeed(100)
