# hero specific logic
#!include "heroes/dva.opy"
#!include "heroes/reinhardt.opy"
#!include "heroes/zarya.opy"

#!include "heroes/mccree.opy"

#!include "heroes/ana.opy"
#!include "heroes/brigitte.opy"
#!include "heroes/bastion.opy"


rule "reset abilities on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    
    waitUntil(eventPlayer.isInSpawnRoom(), 60)
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)

rule "reset abilities on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.hero_switched == true

    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setAbility2Enabled(true)