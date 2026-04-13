#!mainFile "../../main.opy"

#!include "guardian.opy"


def initMercy():
    @Name "[mercy/init.opy]: initMercy()"

    setCustomHp(OW1_MERCY_HEALTH, 0, 0)
    setUltCost(OW1_MERCY_ULT_COST)
    eventPlayer.setAmmo(0, OW1_MERCY_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_MERCY_CLIP_SIZE)

    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)
    setBaseHealing(eventPlayer, OW1_MERCY_STAFF_HEALING/OW2_MERCY_STAFF_HEALING)

    eventPlayer.is_using_guardian_angel = false
    eventPlayer.is_slingshotting = false

rule "[mercy/init.opy]: Comepnsate Damage Reduction":
    @Event playerDealtDamage
    @Hero mercy
    @Condition eventAbility == Button.PRIMARY_FIRE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)