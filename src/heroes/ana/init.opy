#!mainFile "../../dev_main.opy"

#!include "heroes/ana/nade.opy"

playervar ana_damage_check

subroutine startHealPassiveBackUp
subroutine endHealPassiveBackUp


rule "[ana/init.opy]: Ana":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ANA
    
    eventPlayer.ult_change_check = 1.06
    eventPlayer.removeAllHealthPools()
    eventPlayer.setMaxHealth(100)
    resetHealth()
    eventPlayer.addHealthPool(Health.NORMAL, 199, true, true)
    eventPlayer.ana_damage_check = false
    eventPlayer.setMaxAmmo(0, 12)
    eventPlayer.setAmmo(0, 12)
    resetStats()
    resetStatuses()
    enableAllAbilities()
    eventPlayer.setDamageDealt(66.667)
    eventPlayer.setHealingDealt(100)

    removeSelfHealing()


rule "Increase Ana melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ANA
    @Condition eventAbility == Button.MELEE
    
    damage(victim, attacker, eventDamage * 1.778 - eventDamage)


rule "Increase Biotic Rifle damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ANA
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.ana_damage_check == false
    
    eventPlayer.ana_damage_check = true
    victim.startDoT(attacker, 0.55, 64.404)
    wait(0.6)
    eventPlayer.ana_damage_check = false
