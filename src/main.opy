#!include "env/env.opy"

# Useful constants
# !include "constants/ow1_constants.opy"
# !include "constants/ow2_constants.opy"

# Useful functions
# !include "utilities/macro_functions.opy"
# !include "utilities/stat_helper.opy"
# !include "utilities/custom_hp.opy"
#!include "utilities/reset.opy"
#!include "utilities/hero_switch.opy"
# !include "utilities/hero_roster.opy"
# !include "utilities/role_lock.opy"
# !include "utilities/ready.opy"
# !include "utilities/hit_detection.opy"
#!include "utilities/anti_crash.opy"

# Custom game lobby settings
#!include "lobby/lobby.opy"

# OW1 logic
# Remove damage passive
#!include "passives/damage/damage_passive.opy"
# Remove tank passive
# !include "passives/tank/ult_charge.opy"
#!include "passives/tank/knockback.opy"
# Remove support passive
#!include "passives/support/self_heal.opy"

# Include for global scoping
# !include "heroes/sombra/hack.opy"
#!include "heroes/echo/init.opy"

# Hero specific logic
# Tanks
#!include "heroes/dva/init.opy"
#!include "heroes/doomfist/init.opy"
#!include "heroes/junkerqueen/init.opy"
#!include "heroes/mauga/init.opy"
#!include "heroes/orisa/init.opy"
#!include "heroes/ramattra/init.opy"
#!include "heroes/reinhardt/init.opy"
#!include "heroes/roadhog/init.opy"
#!include "heroes/sigma/init.opy"
#!include "heroes/winston/init.opy"
#!include "heroes/wreckingball/init.opy"
#!include "heroes/zarya/init.opy"

# DPS
#!include "heroes/ashe/init.opy"
#!include "heroes/bastion/init.opy"
#!include "heroes/echo/init.opy"
#!include "heroes/genji/init.opy"
#!include "heroes/hanzo/init.opy"
#!include "heroes/junkrat/init.opy"
#!include "heroes/mccree/init.opy"
#!include "heroes/mei/init.opy"
#!include "heroes/pharah/init.opy"
#!include "heroes/reaper/init.opy"
#!include "heroes/sojourn/init.opy"
#!include "heroes/soldier/init.opy"
#!include "heroes/sombra/init.opy"
#!include "heroes/symmetra/init.opy"
#!include "heroes/torbjorn/init.opy"
#!include "heroes/tracer/init.opy"
#!include "heroes/venture/init.opy"
#!include "heroes/widowmaker/init.opy"

# Supports
#!include "heroes/ana/init.opy"
#!include "heroes/baptiste/init.opy"
#!include "heroes/brigitte/init.opy"
#!include "heroes/illari/init.opy"
#!include "heroes/kiriko/init.opy"
#!include "heroes/lifeweaver/init.opy"
#!include "heroes/lucio/init.opy"
#!include "heroes/mercy/init.opy"
#!include "heroes/moira/init.opy"
#!include "heroes/zenyatta/init.opy"

# Include debug at the end so any variable can be viewed
# !include "utilities/debug.opy"

# !include "utilities/watermark.opy"


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

/*
rule "(Duplicate) pile cooldown":
*/

/*
rule "(Duplicate) Healing Pylon cooldown":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.getHeroOfDuplication() == Hero.ILLARI
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
*/

/*
rule "(Duplicate) Plat cooldown":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.LIFEWEAVER
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 10)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0, 99999)
*/

/*
rule "76 backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.heal_state == 0
    
    eventPlayer.heal_state = 1
    eventPlayer.setHealingDealt(1)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0, 9999999)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0, 9999999)
    eventPlayer.setHealingDealt(0)
    eventPlayer.heal_state = 0
*/

/*
rule "76 heal":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.SOLDIER
    @Condition eventAbility == Button.ABILITY_2
    
    heal(eventPlayer, null, eventHealing * 87.6)
*/

rule "hog backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.heal_state == 0
    
    eventPlayer.heal_state = 1
    eventPlayer.setHealingDealt(1)
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0, 9999999)
    waitUntil(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0, 9999999)
    eventPlayer.setHealingDealt(0)
    eventPlayer.heal_state = 0


rule "hog heal":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.ROADHOG
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    heal(eventPlayer, eventPlayer, eventHealing * 65.5)


rule "reaper backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.REAPER
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2()) == true
    
    healPassiveReset()
    eventPlayer.setHealingDealt(0)
    waitUntil(not (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2()), 99999)
    healPassiveReset()
    eventPlayer.setHealingDealt(100)


rule "hacked health packs":
    @Event playerReceivedHealing
    @Condition eventWasHealthPack == true
    @Condition eventHealing <= 70
    
    heal(eventPlayer, eventPlayer, eventHealing * 99)


rule "mei backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MEI
    @Condition eventPlayer.isUsingAbility1() == true
    
    healPassiveReset()
    eventPlayer.setHealingDealt(1)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    healPassiveReset()
    eventPlayer.setHealingDealt(0)


rule "mei heal (up to 1 bugged heal)":
    @Event playerDealtHealing
    @Condition eventPlayer.hero_setup == Hero.MEI
    @Condition eventAbility == Button.ABILITY_1
    
    heal(eventPlayer, eventPlayer, eventHealing * 79)


rule "kiri suzu backup":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.KIRIKO
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    if eventPlayer.getMaxHealth() != eventPlayer.getHealth():
        healPassiveReset()


rule "moira backup (up to 18 bugged heal)":
    @Event eachPlayer
    @Condition eventPlayer.hero_setup == Hero.MOIRA
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.heal_state == 1
    
    eventPlayer.heal_state = 0
    healPassiveReset()
    waitUntil(eventPlayer.isUsingAbility1(), 99999)
    waitUntil(not eventPlayer.isUsingAbility1(), 9999999)
    healPassiveReset()
    eventPlayer.heal_state = 1


rule "Increase Firestrike damage (early animation)":
    @Event playerDealtDamage
    @Condition eventPlayer.hero_setup == Hero.REINHARDT
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setDamageDealt(83.333)
    wait(1)
    eventPlayer.setDamageDealt(80)
