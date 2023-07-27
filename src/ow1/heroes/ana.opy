#!mainFile "../../main.opy"

subroutine initAna

rule "[ana.opy]: Detect Ana initialization":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initAna()
    eventPlayer.initialized = true


def initAna():
    @Name "[ana.opy]: initAna()"
    eventPlayer.setDamageDealt(percent(OW1_ANA_SLEEP_DART_DAMAGE/OW2_ANA_SLEEP_DART_DAMAGE))
    eventPlayer.setAmmo(0, OW1_ANA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ANA_CLIP_SIZE)

    removeSelfHealing()


rule "[ana.opy]: Set default sleep dart cooldown":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_ANA_SLEEP_DART_COOLDOWN_TIME)


rule "[ana.opy]: Sleep tanks for longer duration":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in getTankHeroes()
    @Condition eventPlayer.hasStatusEffect(Status.ASLEEP)
    
    eventPlayer.setStatusEffect(null, Status.ASLEEP, 5/3.25*OW1_ANA_SLEEP_DART_SLEEP_DURATION) # 5/3.5 is the ratio of regular sleep time to tank sleep time


rule "[ana.opy]: Heal OW1 healing with biotic grenade":
    @Event playerDealtHealing
    @Hero ana
    @Condition eventAbility == Button.ABILITY_2

    heal(healee, healer, eventHealing*(OW1_ANA_BIOTIC_GRENADE_HEALING/OW2_ANA_BIOTIC_GRENADE_HEALING)-eventHealing)


rule "[ana.opy]: Allow self healing during Biotic Grenade":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingAbility2()

    eventPlayer.self_healing_percent = 100
    waitUntil(eventPlayer.isUsingAbility2() == false, 9999)
    eventPlayer.self_healing_percent = 0
