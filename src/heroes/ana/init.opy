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
    setBaseDamage(eventPlayer, ADJ_ANA_BIOTIC_GRENADE_DAMAGE/OW2_ANA_BIOTIC_GRENADE_DAMAGE)
    eventPlayer.setHealingDealt(100)

    removeSelfHealing()


rule "[ana/init.opy]: Correct Biotic Rifle, Sleep Dart, Melee damage":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.ANA
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.MELEE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
