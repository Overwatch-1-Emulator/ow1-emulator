#!mainFile "../../dev_main.opy"


playervar defense_pvar
#!defineMember current_health defense_pvar[0]
#!defineMember ow1_best_defense_shields defense_pvar[1]
#!defineMember ow2_best_defense_overhealth defense_pvar[3]

macro storedDefenseHealth():
    eventPlayer.current_health = eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) 

rule "[doomfist/defense.opy]: Override OW2 best defense + Custom OW1 best defense":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition any([eventAbility == i for i in [Button.SECONDARY_FIRE, Button.ULTIMATE, Button.ABILITY_1]]) or eventPlayer.is_using_uppercut

    storedDefenseHealth()
    wait() # Try prevent crashes as much as possible
    eventPlayer.ow1_best_defense_shields = eventPlayer.getHealthOfType(Health.SHIELDS) # Detect how much shields you have right now so you dont get under shields
    if eventAbility == Button.ULTIMATE: # Meteor Strike shields
        eventPlayer.ow2_best_defense_overhealth = eventPlayer.getHealth() - eventPlayer.current_health # Detect OW2 best defense
        eventPlayer.setHealth(eventPlayer.ow2_best_defense_overhealth) # Overwrite OW2 best defense
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX - victim.getHealth(), 
            eventPlayer.ow1_best_defense_shields + OW1_DOOMFIST_BEST_DEFENSE_ULT), false, false)
    else: # Slam, Punch, Uppercut shields
        eventPlayer.ow2_best_defense_overhealth = eventPlayer.getHealth() - eventPlayer.current_health # Detect OW2 best defense
        eventPlayer.setHealth(eventPlayer.ow2_best_defense_overhealth) # Overwrite OW2 best defense
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX - victim.getHealth()
        wait(0.4)
            eventPlayer.ow1_best_defense_shields + OW1_DOOMFIST_BEST_DEFENSE), false, false)

    if eventPlayer.getHealthOfType(Health.SHIELDS) > eventPlayer.getMaxHealthOfType(Health.SHIELDS) + OW1_DOOMFIST_BEST_DEFENSE_MAX: # Correct shields if over max shields limit
        removeHealthPool(getLastCreatedHealthPool())
        eventPlayer.addHealthPool(Health.SHIELDS, OW1_DOOMFIST_BEST_DEFENSE_MAX, false, false)
        return
    
rule "[doomfist/defense.opy] Decay Best Defense shields": # Logic by Alomare: https://workshop.codes/E1EW0
    @Event eachPlayer
    @Hero doomfist
    # @Condition not eventPlayer.isUsingUltimate()
    @Condition eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) > 0
    
    wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER, Wait.RESTART_WHEN_TRUE)
    storedDefenseHealth()
    wait() # Try prevent crashes as much as possible
    while eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL) > 0:
        if eventPlayer.getMaxHealth() - eventPlayer.getMaxHealthOfType(Health.NORMAL)  > eventPlayer.current_health:
            loop()
        if eventPlayer.getHealth() < eventPlayer.getMaxHealth():
            eventPlayer.ow2_best_defense_overhealth = eventPlayer.getHealth() - eventPlayer.current_health
            while eventPlayer.getHealth() > eventPlayer.ow2_best_defense_overhealth:
                eventPlayer.setHealth(eventPlayer.ow2_best_defense_overhealth)
            eventPlayer.current_health -= OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE
            if eventPlayer.current_health < 1:
                return
            eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.current_health, false, false)
        else:
            eventPlayer.setHealth(eventPlayer.getHealth() - OW1_DOOMFIST_BEST_DEFENSE_DECAY_RATE)
            storedDefenseHealth()
        wait(OW1_DOOMFIST_BEST_DEFENSE_LINGER)

    
