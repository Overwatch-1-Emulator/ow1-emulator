#!mainFile "../../main.opy"

def initAna():
    eventPlayer.setDamageDealt(percent(OW1_ANA_DART_DAMAGE/OW2_ANA_DART_DAMAGE))
    eventPlayer.setAmmo(0, OW1_ANA_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ANA_CLIP_SIZE)

rule "[ana.opy]: Initialize Ana":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initAna()
    eventPlayer.initialized = true

rule "[ana.opy]: Set default sleep dart cooldown":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_ANA_SLEEP_COOLDOWN)

rule "[ana.opy]: Sleep tanks for longer duration":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() in getTankHeroes()
    @Condition eventPlayer.hasStatusEffect(Status.ASLEEP)
    
    eventPlayer.setStatusEffect(null, Status.ASLEEP, 5/3.25*ow1_sleepdart_sleep_duration) # 5/3.5 is the ratio of regular sleep time to tank sleep time