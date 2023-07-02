#!mainFile "../../main.opy"

def resetHero():
    @Name "[generic.opy]: Reset hero stats"
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)
    
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)

    eventPlayer.clearStatusEffect(Status.ROOTED)

    eventPlayer.reset_flag = true

    
rule "[generic.opy]: Reset hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    
    waitUntil(eventPlayer.isInSpawnRoom(), 60)
    resetHero()


rule "[generic.opy]: Reset hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    resetHero()
