#!mainFile "../../dev_main.opy"


rule "D.va (mech)":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.DVA
    @Condition eventPlayer.isInAlternateForm() == false
    
    eventPlayer.ult_change_check = 1
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 299 if eventPlayer.isDuplicatingAHero() or setting_echo_tank_hp else 349, true, true)
    eventPlayer.addHealthPool(Health.ARMOR, 150 if eventPlayer.isDuplicatingAHero() or setting_echo_tank_hp else 200, true, true)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    removeTankPassive()
    removeSelfHealing()
    if eventPlayer.getMaxHealth() != (450 if eventPlayer.isDuplicatingAHero() or setting_echo_tank_hp else 550):
        goto RULE_START


rule "D.va (pilot)":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.DVA
    @Condition eventPlayer.isInAlternateForm() == true
    
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(85.714)
    eventPlayer.removeAllHealthPools()
    #resetHealth()
    #eventPlayer.addHealthPool(Health.NORMAL, 149, true, true)
    #resetStats()
    #resetStatuses()
    #resetUltCharge()
    #enableAllAbilities()
    removeTankPassive()
    removeSelfHealing()
    #Reset ultimate charge when DVa pops out of Mech
    if eventPlayer.isUsingUltimate():
        return
    resetUltCharge()

/*
rule "(Duplicate) d.va dm fix a":
    @Event eachPlayer
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DVA
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) > 66
    
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 66)
*/

/*
rule "(Duplicate) d.va dm fix b":
    @Event eachPlayer
    @Condition eventPlayer.getHeroOfDuplication() == Hero.DVA
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) > 66
    
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 100)
*/
