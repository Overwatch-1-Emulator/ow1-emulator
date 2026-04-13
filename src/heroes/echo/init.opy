#!mainFile "../../main.opy"

#!include "focusing_beam.opy"
#!include "duplicate.opy"
# !include "newduplicate.opy"

def initEcho():
    @Name "[echo/init.opy]: initEcho()"

    setCustomHp(OW1_ECHO_HEALTH-1, 0, 0) # Need to subtract 1 because of extra 1 shield health
    setUltCost(OW1_ECHO_ULT_COST)
    setBaseDamage(eventPlayer, 1/OW2_MELEE_DAMAGE)


rule "[echo/init.opy]: Compensate Echo global damage reduction":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage-OW1_ARMOR_DAMAGE_REDUCTION)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)

