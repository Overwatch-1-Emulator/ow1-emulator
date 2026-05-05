#!mainFile "../../main.opy"

#!include "hover_jets.opy"
#!include "rocket_launcher.opy"
#!include "concussive.opy"
#!include "barrage.opy"


def initPharah():
    @Name "[pharah/init.opy]: initPharah()"

    setCustomHp(OW1_PHARAH_HEALTH, 0, 0)
    setUltCost(OW1_PHARAH_ULT_COST)
    setBaseDamage(eventPlayer, OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE) #set it to 1 so its the lowest amount of damage possible

    initHoverJets()


rule "[pharah/init.opy]: Clean up Pharah":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.PHARAH

    waitUntil(eventPlayer.getCurrentHero() != Hero.PHARAH, Math.INFINITY)
    hideFuelGui()

rule "[pharah/init.opy]: Compensate Pharah global damage reduction":
    @Event playerDealtDamage
    @Hero pharah
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
    

rule "im super bored":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.isUsingAbility1()

    eventPlayer.applyImpulse(Vector.UP, OW1_PHARAH_JUMP_JET_RANGE-OW2_PHARAH_JUMP_JET_RANGE, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)