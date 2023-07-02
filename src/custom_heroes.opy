# hero specific logic
#!include "heroes/dva.opy"
#!include "heroes/reinhardt.opy"
#!include "heroes/zarya.opy"

#!include "heroes/bastion.opy"
#!include "heroes/mccree.opy"

#!include "heroes/ana.opy"
#!include "heroes/brigitte.opy"

def resetHero():
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)

rule "[custom_heroes.opy]: reset abilities on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    
    waitUntil(eventPlayer.isInSpawnRoom(), 60)
    resetHero()

rule "[custom_heroes.opy]: reset abilities on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    resetHero()