#!mainFile "../../main.opy"


rule "[reaper/blossom.opy]: OW1 Death Blossom damage":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.ULTIMATE

    if victim.getHealthOfType(Health.ARMOR) > 0:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_REAPER_DEATH_BLOSSOM_DAMAGE_VS_ARMOR/OW2_REAPER_DEATH_BLOSSON_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
    else:
        damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar*(OW1_REAPER_DEATH_BLOSSON_DAMAGE/OW2_REAPER_DEATH_BLOSSON_DAMAGE) - eventDamage)/eventPlayer._base_damage_scalar)
