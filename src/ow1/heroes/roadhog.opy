#!mainFile "../../main.opy"

def initRoadhog():
    eventPlayer.setAmmo(0, OW1_ROADHOG_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_ROADHOG_CLIP_SIZE)

    eventPlayer.setDamageDealt(percent(OW1_ROADHOG_SHOTGUN_DAMAGE/OW2_ROADHOG_SHOTGUN_DAMAGE))

rule "[roadhog.opy]: Initialize Roadhog":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.reset_flag == true # without this flag, the reset code in generic.opy executes after initialization

    initRoadhog()

rule "[roadhog.opy]: Set default hook cooldown":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(not eventPlayer.isUsingAbility1(), 9999)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, OW1_ROADHOG_HOOK_COOLDOWN)