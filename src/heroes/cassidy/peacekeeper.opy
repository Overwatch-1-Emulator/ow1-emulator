#!mainFile "../../main.opy"

playervar cassidy_falloff_pvar
#!defineMember cassidy_shot_distance          cassidy_falloff_pvar[0]
#!defineMember cassidy_ow1_falloff_scalar     cassidy_falloff_pvar[1]

#!define OW1CassidyN(d) ((d - OW1_CASSIDY_DAMAGE_FALLOFF_START_DISTANCE)/(OW1_CASSIDY_DAMAGE_FALLOFF_END_DISTANCE - OW1_CASSIDY_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1CassidyFalloff(d) ((OW1CassidyN(d)) * OW1_CASSIDY_DAMAGE_FALLOFF_SCALAR + (1 - OW1CassidyN(d)))


rule "[cassidy/init.opy]: OW1 Peacekeeper Damage falloff":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition not eventPlayer.isUsingUltimate()

    eventPlayer.cassidy_shot_distance = distance(attacker.getEyePosition(), victim)
    if eventPlayer.cassidy_shot_distance < OW1_CASSIDY_DAMAGE_FALLOFF_START_DISTANCE:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
    elif eventPlayer.cassidy_shot_distance <= OW1_CASSIDY_DAMAGE_FALLOFF_END_DISTANCE:
        eventPlayer.cassidy_ow1_falloff_scalar = OW1CassidyFalloff(eventPlayer.cassidy_shot_distance)
        if eventPlayer.cassidy_ow1_falloff_scalar > 1: eventPlayer.cassidy_ow1_falloff_scalar = 1
        elif eventPlayer.cassidy_ow1_falloff_scalar < OW1_CASSIDY_DAMAGE_FALLOFF_SCALAR: eventPlayer.cassidy_ow1_falloff_scalar = OW1_CASSIDY_DAMAGE_FALLOFF_SCALAR
        damage(victim, attacker, (OW1_CASSIDY_PEACEKEEPER_DAMAGE * eventPlayer.cassidy_ow1_falloff_scalar - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (OW1_CASSIDY_PEACEKEEPER_DAMAGE * OW1_CASSIDY_DAMAGE_FALLOFF_SCALAR - eventDamage)/eventPlayer._base_damage_scalar)
