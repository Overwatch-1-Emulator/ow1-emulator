#!mainFile "../main.opy"

playervar stat_helper_pvar
#!defineMember _base_damage_scalar stat_helper_pvar[0]

#!define setBaseDamage(player, scalar) \
    player._base_damage_scalar = scalar \
    player.setDamageDealt(percent(player._base_damage_scalar))


rule "[stat_helper.opy]: OW1 melee damage":
    @Event playerDealtDamage
    @Condition eventAbility == Button.MELEE
    @Condition eventPlayer.getCurrentHero() != Hero.ASHE
    @Condition eventPlayer.getCurrentHero() != Hero.WINSTON

    heal(victim, null, eventDamage - eventDamage*(OW1_MELEE_DAMAGE/OW2_MELEE_DAMAGE))
