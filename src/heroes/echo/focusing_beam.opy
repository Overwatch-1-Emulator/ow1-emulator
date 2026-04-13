#!mainFile "../../main.opy"


rule "[echo/focusing_beam.opy]: Deal OW1 echo focusing beam under 50% hp":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventPlayer.isUsingAbility2()
    @Condition percent(victim.getHealth()/victim.getMaxHealth()) < OW1_ECHO_FOCUSING_BEAM_TRESHOLD

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ECHO_FOCUSING_BEAM_DMG/OW2_ECHO_FOCUSING_BEAM_DMG) - eventDamage)/eventPlayer._base_damage_scalar)

rule "[echo/focusing_beam.opy]: Deal OW1 echo focusing beam not under 50% hp":
    @Event playerDealtDamage
    @Hero echo
    @Condition eventPlayer.isUsingAbility2()
    @Condition not percent(victim.getHealth()/victim.getMaxHealth()) < OW1_ECHO_FOCUSING_BEAM_TRESHOLD

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ECHO_FOCUSING_BEAM_DMG_NON_PIERCE_VS_ARMOR/OW2_ECHO_FOCUSING_BEAM_DMG_NON_PIERCE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_ECHO_FOCUSING_BEAM_DMG_NON_PIERCE/OW2_ECHO_FOCUSING_BEAM_DMG_NON_PIERCE) - eventDamage)/eventPlayer._base_damage_scalar)