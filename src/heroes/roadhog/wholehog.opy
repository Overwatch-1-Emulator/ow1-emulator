#!mainFile "../../main.opy"

playervar wholehog_pvar
#!defineMember _is_exiting_wholehog wholehog_pvar[0]
#!defineMember _hog_hp reset_pvar[1]
#!defineMember _hook_cooldown wholehog_pvar[2]
#!defineMember _breather_cooldown wholehog_pvar[3]
#!defineMember _scrap_ammo wholehog_pvar[4]

subroutine cancelWholehog


rule "[roadhog/wholehog.opy]: OW1 disable abilities during wholehog":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    
    eventPlayer.setMeleeEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAbility2Enabled(false)


rule "[roadhog/wholehog.opy]: OW1 enable abilities when not in wholehog":
    @Event eachPlayer
    @Hero roadhog
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.setMeleeEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[roadhog/wholehog.opy]: OW1 Wholehog force autofire":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    @Condition not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "[roadhog/wholehog.opy]: Cancel ult when stunned":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    @Condition isCCd(eventPlayer)

    if isHacked(eventPlayer):
        # waitUntil(not isHacked(eventPlayer), Math.INFINITY) # if hacked, instantly cancel ult
        pass
    elif eventPlayer.hasStatusEffect(Status.FROZEN):
        waitUntil(not eventPlayer.hasStatusEffect(Status.FROZEN), Math.INFINITY)
    elif eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN):
        waitUntil(not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN), Math.INFINITY)
    elif eventPlayer.hasStatusEffect(Status.ASLEEP):
        waitUntil(not eventPlayer.hasStatusEffect(Status.ASLEEP), Math.INFINITY)
    elif eventPlayer.hasStatusEffect(Status.STUNNED):
        waitUntil(not eventPlayer.hasStatusEffect(Status.STUNNED), Math.INFINITY)
    
    if eventPlayer.isUsingUltimate():
        eventPlayer._scrap_ammo = eventPlayer.getAmmo(0)
        cancelWholehog()


rule "[roadhog/wholehog.opy]: Reduce ultimate duration":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingUltimate()
    
    wait(OW1_ROADHOG_ULTIMATE_DURATION, Wait.ABORT_WHEN_FALSE)
    eventPlayer._scrap_ammo = OW1_ROADHOG_CLIP_SIZE
    cancelWholehog()


# Switch to Zarya temporarily to remove wholehog
def cancelWholehog():
    @Name "[roadhog/wholehog.opy]: cancelWholehog()"

    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    
    # Save hog state
    eventPlayer._hog_hp = eventPlayer.getHealth()
    eventPlayer._hook_cooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_1)
    eventPlayer._breather_cooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_2)

    eventPlayer._is_exiting_wholehog = true
    eventPlayer.startForcingHero(Hero.ZARYA)


# Switch back to roadhog after entering zarya
rule "[roadhog/wholehog.opy]: Go back to roadhog":
    @Event eachPlayer
    @Condition eventPlayer._is_exiting_wholehog

    eventPlayer.startForcingHero(Hero.ROADHOG)
    eventPlayer.stopForcingCurrentHero()

    # Restore hog state
    setCustomHp(eventPlayer._hp_health, eventPlayer._hp_armor, eventPlayer._hp_shields)
    eventPlayer.setHealth(eventPlayer._hog_hp)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer._hook_cooldown)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer._breather_cooldown)

    eventPlayer.setAmmo(0, eventPlayer._scrap_ammo)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE) # Without this, hog gets his ow2 clip size back

    eventPlayer._is_exiting_wholehog = false
