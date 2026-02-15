#!mainFile "../../dev_main.opy"


rule "[doomfist/bestdefense.opy]: Track Doom Health for Best Defense":
    @Event eachPlayer
    @Hero doomfist
    eventPlayer.A = eventPlayer.getHealthOfType(Health.NORMAL)
    #eventPlayer.D = eventPlayer.getHealthOfType(Health.SHIELDS)
    #eventPlayer.F = eventPlayer._uppercut_victims
    wait(0.016)
    loop()

rule "[doomfist/bestdefense.opy]: Add Best defense health":
    @Event playerDealtDamage
    @Hero doomfist
    #@Condition victim != attacker
    @Condition any([eventAbility == i for i in [Button.SECONDARY_FIRE, Button.ULTIMATE, Button.ABILITY_1]]) == true
     



    eventPlayer.decay_timer = 0.6
    eventPlayer.G = eventPlayer.getHealthOfType(Health.SHIELDS)
    #if eventPlayer.getHealth() >= eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS) + 150:
    if eventAbility == Button.ULTIMATE :
        eventPlayer.setHealth(eventPlayer.A)
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + 150 - victim.getHealth(), eventPlayer.G+75), false, false)
    else:
        eventPlayer.setHealth(eventPlayer.A)
        eventPlayer.addHealthPool(Health.SHIELDS, min(victim.getMaxHealthOfType(Health.NORMAL) + victim.getMaxHealthOfType(Health.ARMOR) + victim.getMaxHealthOfType(Health.SHIELDS) + 150 - victim.getHealth(), eventPlayer.G+30), false, false)
        wait(0.4)
    if eventPlayer.getHealthOfType(Health.SHIELDS) > eventPlayer.getMaxHealthOfType(Health.SHIELDS) + 150:
        removeHealthPool(getLastCreatedHealthPool())
        eventPlayer.setHealth(eventPlayer.A)
        eventPlayer.addHealthPool(Health.SHIELDS, 150, false, false)
        return

rule "[doomfist/bestdefense.opy]: Decay Health":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) == true
    #@Condition eventPlayer.getHealth() > eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    #try getmaxhealth to shields then that
    if eventPlayer.decay_timer == 0 and eventPlayer.hasStatus(Status.ASLEEP) == false:
        damage(eventPlayer, null, 0.3)
        #eventPlayer.setHealth(max(getLastCreatedHealthPool(), eventPlayer.getHealth() - 0.3))
        #eventPlayer.setHealth(max(eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS), eventPlayer.getHealth() - 0.3))
    else:
        eventPlayer.decay_timer -= 0.1
    wait(0.1)
    if ruleCondition:
        loop()