#!mainFile "../../main.opy"

#!include "hover_jets.opy"
#!include "rocket_launcher.opy"
#!include "concussive.opy"


def initPharah():
    @Name "[pharah/init.opy]: initPharah()"

    setCustomHp(OW1_PHARAH_HEALTH, 0, 0)
    setUltCost(OW1_PHARAH_ULT_COST)
    setBaseDamage(eventPlayer, 1/OW2_PHARAH_CONCUSSIVE_BLAST_DAMAGE)

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

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - OW2_ARMOR_DAMAGE_REDUCTION - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)