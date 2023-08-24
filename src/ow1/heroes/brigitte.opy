#!mainFile "../../main.opy"
# Credit to oreoslurpee for Brigitte shield bash logic
# see https://workshop.codes/MR5QJ for oreslurpee's 2018 brig implementation

playervar inspire_duration


rule "[brigitte.opy]: Initialize Brigitte":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    do:
        clearCustomHealth()
        setCustomHealth(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
        wait(1)
    while (eventPlayer.getMaxHealth() != OW1_BRIGITTE_HEALTH + OW1_BRIGITTE_ARMOR)


rule "[brigitte.opy]: Fix inspire self heal":
    @Event playerDealtDamage
    @Hero brigitte

    stopChasingVariable(eventPlayer.inspire_duration)
    eventPlayer.inspire_duration = 0
    chase(eventPlayer.inspire_duration, OW1_BRIGITTE_INSPIRE_DURATION, rate=1, ChaseReeval.NONE)
    eventPlayer.self_healing_percent = 100


rule "[brigitte.opy]: No self healing when inspire timer runs out":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.inspire_duration >= OW1_BRIGITTE_INSPIRE_DURATION

    stopChasingVariable(eventPlayer.inspire_duration)
    eventPlayer.self_healing_percent = 0


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


rule "[brigitte.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setMoveSpeed(100)
