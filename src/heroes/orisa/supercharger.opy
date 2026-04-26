#!mainFile "../../main.opy"

playervar supercharger_pvar

#!defineMember is_using_supercharger supercharger_pvar[0]
#!defineMember is_supercharged supercharger_pvar[1]
#!defineMember orisa_supercharger_id supercharger_pvar[2]
#!defineMember orisa_supercharger_origin supercharger_pvar[3]
#!defineMember orisa_supercharger_beam_id supercharger_pvar[4]
#!defineMember orisa_supercharger_sound_id supercharger_pvar[5]
#!defineMember javelin_cooldown_before_ult supercharger_pvar[6]
#!defineMember is_starting_supercharger supercharger_pvar[7]
#!defineMember supercharger_hp supercharger_pvar[8]
#!defineMember supercharger_hp_hud_id supercharger_pvar[9]

subroutine startSupercharger
subroutine endSupercharger


rule "[orisa/supercharger.opy]: Detect Supercharger animation": # DONT SWITCH THIS RULE ORDER! THIS IS IMPORTANT!
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.getUltCharge() >= 100

    eventPlayer.is_starting_supercharger = true
    wait(TICK_DURATION, Wait.IGNORE_CONDITION)
    eventPlayer.is_starting_supercharger = false


rule "[orisa/supercharger.opy]: Trigger Supercharger start":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.getUltCharge() >= 100

    endSupercharger() # Destroy any existing Supercharger
    waitUntil(eventPlayer.isOnGround(), Math.INFINITY)
    startSupercharger() # Start new supercharger
    wait(OW1_ORISA_SUPERCHARGER_MAX_DURATION, Wait.RESTART_WHEN_TRUE) # Start supercharger timer
    endSupercharger()


def startSupercharger():
    @Name "[orisa/supercharger.opy]: startSupercharger()"

    eventPlayer.orisa_supercharger_origin = eventPlayer.getPosition() + OW1_ORISA_SUPERCHARGER_HEIGHT/2*Vector.UP

    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(false) # Prevent Orisa from getting ult charge
    eventPlayer.communicate(Comms.VOICE_LINE_UP) # Play ultimate voice line

    # Supercharge GUI
    if eventPlayer.orisa_supercharger_id[0] == null:
        createEffect(getAllPlayers(),
                     Effect.SPHERE,
                     Color.LIME_GREEN,
                     eventPlayer.orisa_supercharger_origin + OW1_ORISA_SUPERCHARGER_HEIGHT/4*Vector.UP,
                     OW1_ORISA_SUPERCHARGER_HEIGHT/3,
                     EffectReeval.NONE)
        eventPlayer.orisa_supercharger_id[0] = getLastCreatedEntity()
    if eventPlayer.orisa_supercharger_id[1] == null:
        createEffect(getAllPlayers(),
                     Effect.SPHERE,
                     Color.LIME_GREEN,
                     eventPlayer.orisa_supercharger_origin + OW1_ORISA_SUPERCHARGER_HEIGHT/4*Vector.DOWN,
                     OW1_ORISA_SUPERCHARGER_HEIGHT/3,
                     EffectReeval.NONE)
        eventPlayer.orisa_supercharger_id[1] = getLastCreatedEntity()
    # Supercharge HP
    eventPlayer.supercharger_hp = OW1_ORISA_SUPERCHARGER_HEALTH
    progressBarHud(eventPlayer,
               percent(eventPlayer.supercharger_hp / OW1_ORISA_SUPERCHARGER_HEALTH),
               "{}".format(ceil(eventPlayer.supercharger_hp)),
               HudPosition.TOP,
               Math.INFINITY,
               Color.LIME_GREEN,
               Color.WHITE,
               ProgressHudReeval.VALUES,
               SpecVisibility.DEFAULT)
    eventPlayer.supercharger_hp_hud_id = getLastCreatedText()

    # Supercharger deploy effect
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.GREEN, eventPlayer.orisa_supercharger_origin, 3)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.GREEN, eventPlayer.orisa_supercharger_origin, 200)
    # play Javelin vfx
    eventPlayer.javelin_cooldown_before_ult = eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.cancelPrimaryAction() # Cancel vfx
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, eventPlayer.javelin_cooldown_before_ult)

    # Announce supercharger active
    eventPlayer.is_using_supercharger = true


def endSupercharger():
    @Name "[orisa/supercharger.opy]: endSupercharger()"

    eventPlayer.setUltEnabled(true)
    destroyEffect(eventPlayer.orisa_supercharger_id[0])
    eventPlayer.orisa_supercharger_id[0] = null
    destroyEffect(eventPlayer.orisa_supercharger_id[1])
    eventPlayer.orisa_supercharger_id[1] = null
    eventPlayer.is_using_supercharger = false
    getPlayers(eventPlayer.getTeam()).is_supercharged = false
    destroyProgressBarHud(eventPlayer.supercharger_hp_hud_id)


rule "[orisa/supercharger.opy]: Supercharge teammates in supercharger range":
    @Event eachPlayer
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger
    @Condition (distance(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_origin) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS and \
               isInLoS(eventPlayer, eventPlayer.friendly_orisa_player.orisa_supercharger_origin, BarrierLos.PASS_THROUGH_BARRIERS))
    @Condition eventPlayer.isAlive()

    eventPlayer.is_supercharged = true


rule "[orisa/supercharger.opy]: De-supercharge teammates outside supercharger range":
    @Event eachPlayer
    @Condition eventPlayer.friendly_orisa_player.is_using_supercharger
    @Condition eventPlayer.is_supercharged
    @Condition not (distance(eventPlayer,
                             eventPlayer.friendly_orisa_player.orisa_supercharger_origin) <= OW1_ORISA_SUPERCHARGER_AOE_RADIUS \
                    and \
                    isInLoS(eventPlayer,
                            eventPlayer.friendly_orisa_player.orisa_supercharger_origin,
                            BarrierLos.PASS_THROUGH_BARRIERS))

    wait(OW1_ORISA_SUPERCHARGER_LINGER_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.is_supercharged = false


rule "[orisa/supercharger.opy]: De-supercharge teammates when supercharger ends":
    @Event eachPlayer
    @Hero orisa
    @Condition not eventPlayer.is_using_supercharger

    getPlayers(eventPlayer.getTeam()).is_supercharged = false


rule "[orisa/supercharger.opy]: De-supercharge teammates when they die":
    @Event playerDied
    @Condition eventPlayer.is_supercharged

    eventPlayer.is_supercharged = false


rule "[orisa/supercharger.opy]: Damage boost player when supercharged":
    @Event eachPlayer
    @Condition eventPlayer.is_supercharged

    eventPlayer.setDamageDealt(percent(OW1_ORISA_SUPERCHARGER_DAMAGE_MULTIPLIER*eventPlayer._base_damage_scalar))

    # Beam and sound effects
    if (eventPlayer.orisa_supercharger_beam_id == null): # beam
        createBeam(getAllPlayers(),
                   Beam.GOOD,
                   eventPlayer.friendly_orisa_player.orisa_supercharger_origin,
                   (eventPlayer.getPosition() + eventPlayer.getEyePosition())/2,
                   Color.BLUE,
                   EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.orisa_supercharger_beam_id = getLastCreatedEntity()
    if (eventPlayer.orisa_supercharger_sound_id == null): # sound
        createEffect(eventPlayer,
                     Effect.ENERGY_SOUND,
                     Color.GREEN,
                     eventPlayer.getPosition(),
                     100,
                     EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.orisa_supercharger_sound_id = getLastCreatedEntity()


rule "[orisa/supercharger.opy]: Revert damage boost if not supercharged":
    @Event eachPlayer
    @Condition not eventPlayer.is_supercharged

    eventPlayer.setDamageDealt(percent(eventPlayer._base_damage_scalar))

    # Beam and sound effects
    destroyEffect(eventPlayer.orisa_supercharger_beam_id)
    eventPlayer.orisa_supercharger_beam_id = null
    destroyEffect(eventPlayer.orisa_supercharger_sound_id)
    eventPlayer.orisa_supercharger_sound_id = null

rule "[orisa/supercharger.opy]: Damage supercharger when shot":
    @Event eachPlayer
    @Condition eventPlayer.getTeam() == getOppositeTeam(eventPlayer.enemy_orisa_player.getTeam())
    @Condition eventPlayer.enemy_orisa_player.is_using_supercharger
    @Condition eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()
    @Condition isAimingAtSphere(eventPlayer.getEyePosition(), eventPlayer.getFacingDirection(), eventPlayer.enemy_orisa_player.orisa_supercharger_origin, 0.5)
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.enemy_orisa_player.orisa_supercharger_origin, BarrierLos.BLOCKED_BY_ALL_BARRIERS)

    eventPlayer.enemy_orisa_player.supercharger_hp -= 10
    wait(0.1, Wait.RESTART_WHEN_TRUE)
    if RULE_CONDITION: goto RULE_START

rule "[orisa/supercharger.opy]: Destroy Supercharger when hp drops":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.supercharger_hp == 0

    endSupercharger()