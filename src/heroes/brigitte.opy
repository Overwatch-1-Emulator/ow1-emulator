# credit to oreoslurpee for 2018 Release Brigitte: https://workshop.codes/MR5QJ

playervar baseHealth 0
playervar healingModification 1
playervar repairPackArmour 2
playervar rallyArmour 3
playervar inspireRefreshPlayer 28
playervar inspireHoT 29


rule "============GENERAL============":


rule "Max Health":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventPlayer.getMaxHealth() >= 400
    
    eventPlayer.setMaxHealth(50)
    waitUntil(eventPlayer.getCurrentHero() != Hero.BRIGITTE, 99999)
    eventPlayer.setMaxHealth(100)


rule "Extra Health":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventPlayer.getMaxHealth() <= 400
    
    eventPlayer.addHealthPool(Health.NORMAL, 50, true, true)
    eventPlayer.baseHealth = getLastCreatedHealthPool()
    waitUntil(eventPlayer.getCurrentHero() != Hero.BRIGITTE, 99999)
    removeHealthPool(eventPlayer.baseHealth)


rule "removals for swapping":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.BRIGITTE, 99999)
    removeHealthPool(eventPlayer.rallyArmour)
    removeHealthPool(eventPlayer.baseHealth)
    stopHealingModification(eventPlayer.healingModification)


rule "remove all hps":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE
    
    startHealingModification(getPlayers(eventPlayer.getTeam()), eventPlayer, 0.1, HealingReeval.RECEIVERS_AND_HEALERS)
    eventPlayer.healingModification = getLastHealingModification()
    waitUntil(eventPlayer.getCurrentHero() != Hero.BRIGITTE, 99999)
    stopHealingModification(eventPlayer.healingModification)


rule "============REPAIR PACK============":


rule "reduce pack charge":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getAbilityCharge(Button.ABILITY_2) == 2
    
    eventPlayer.setAbility2Enabled(false)
    waitUntil(eventPlayer.getAbilityCharge(Button.ABILITY_2) == 3, 99999)
    eventPlayer.setAbility2Enabled(true)


rule "allow ability 2 after switched":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE
    
    waitUntil(not eventPlayer.hasSpawned() or Hero.BRIGITTE != eventPlayer.getCurrentHero(), 99999)
    eventPlayer.setAbility2Enabled(true)


rule "disable repair pack at 20m or more":
    @Event eachPlayer
    @Hero brigitte
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) >= 20
    
    eventPlayer.disallowButton(Button.ABILITY_2)


rule "enable repair pack at 20m or less":
    @Event eachPlayer
    @Hero brigitte
    @Condition distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())) <= 20
    
    eventPlayer.allowButton(Button.ABILITY_2)


rule "repair pack instant heal":
    @Event playerReceivedHealing
    @Condition healer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    #check whether the healee is below full health
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    heal(eventPlayer, healer, 150)
    healer.setUltCharge(healer.getUltCharge() + 9)
    #to prevent the Heal action to repeat continuously
    wait(6)


rule "repair pack bonus armor":
    @Event playerReceivedHealing
    @Condition healer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    #check whether the healee is at full health
    @Condition eventPlayer.getNormalizedHealth() == 1
    
    eventPlayer.addHealthPool(Health.ARMOR, 75, true, false)
    eventPlayer.repairPackArmour = getLastCreatedHealthPool()
    wait(6)
    removeHealthPool(getLastCreatedHealthPool())


rule "repair pack remove armour after damaged":
    @Event playerReceivedHealing
    @Condition healer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventAbility == Button.ABILITY_2
    #check whether the healee is at full health
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    removeHealthPool(eventPlayer.repairPackArmour)


rule "============SHIELD BASH============":


rule "shield bash stun duration":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.9)


rule "shield bash distance":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setMoveSpeed(60)
    wait(0.3)
    eventPlayer.setMoveSpeed(100)


rule "shield bash distance (rally fix)":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(60)
    wait(0.3)
    eventPlayer.setMoveSpeed(113.043)


rule "============RALLY============":


rule "rally speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setMoveSpeed(113.043)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setMoveSpeed(100)


rule "rally heals by 15 health every .5s":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() < 400
    @Condition eventPlayer.isUsingUltimate() == true
    
    heal(eventPlayer, null, 15)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "rally shield size":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.startScalingBarriers(0.95, true)
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.stopScalingBarriers()


rule "rally extra armor":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.addHealthPool(Health.ARMOR, 50, true, true)
    eventPlayer.rallyArmour = getLastCreatedHealthPool()
    waitUntil(not eventPlayer.isUsingUltimate(), 99999)
    removeHealthPool(eventPlayer.rallyArmour)


rule "============INSPIRE============":


rule "remake of inspire":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.inspireRefreshPlayer != null
    
    if eventPlayer.inspireHoT != null:
        stopHoT(eventPlayer.inspireHoT)
    eventPlayer.startHoT(eventPlayer.inspireRefreshPlayer, 5, 16)
    eventPlayer.inspireHoT = getLastHoT()
    eventPlayer.inspireRefreshPlayer = null
    wait(1.5)
    if RULE_CONDITION:
        goto RULE_START


rule "flag inspired players":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility != null
    @Condition eventPlayer.isFiringSecondaryFire() != true
    
    getPlayersInRadius(eventPlayer.getEyePosition(), 20, eventPlayer.getTeam(), LosCheck.SURFACES).inspireRefreshPlayer = eventPlayer


rule "============WORKAROUNDS============":


/*
rule ">= 250 hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() > 250
    @Condition eventPlayer.isUsingUltimate() != true
    
    damage(eventPlayer, null, eventPlayer.getHealth() - 248.5)
    wait()
    if RULE_CONDITION:
        goto RULE_START
*/

/*
rule "50 armor dmg reduction hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() >= 201
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setDamageReceived(70)
*/

/*
rule "200 health removes dmg reduction hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() <= 200
    
    eventPlayer.setDamageReceived(100)
*/

/*
rule "limit >250 hp for no heals":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() > 250
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setHealingReceived(0)
*/

/*
rule "make <250 hp be healable":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() <= 250
    @Condition eventPlayer.isUsingUltimate() != true
    
    eventPlayer.setHealingReceived(100)
*/

/*
rule "(RALLY) >= 400 hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() > 399.98
    @Condition eventPlayer.isUsingUltimate() == true
    
    damage(eventPlayer, null, eventPlayer.getHealth() - 399.98)
    wait()
    if RULE_CONDITION:
        goto RULE_START
*/

/*
rule "(RALLY) limit >400 hp for no heals":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() > 399.98
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setHealingReceived(0)
*/

/*
rule "(RALLY) <400 hp be healable":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.getHealth() <= 399.98
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setHealingReceived(100)
*/

