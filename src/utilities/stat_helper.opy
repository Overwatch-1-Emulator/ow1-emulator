#!mainFile "../main.opy"

playervar stat_helper_pvar
#!defineMember _base_damage_scalar stat_helper_pvar[0]

#!define setBaseDamage(player, scalar) \
    player._base_damage_scalar = scalar \
    player.setDamageDealt(percent(player._base_damage_scalar))
