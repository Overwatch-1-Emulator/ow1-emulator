#!mainFile "../../main.opy"


# rule "[roadhog/hook.opy]: Move hooked enemies closer":
#     @Event playerDealtDamage
#     @Hero roadhog
#     @Condition eventPlayer.isUsingAbility1()

#     waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
#     if distance(victim, attacker) <= OW2_ROADHOG_HOOK_PROXIMITY + 1:
#         victim.teleport(
#             raycast(
#                 victim.getPosition(), 
#                 victim.getPosition() + (OW2_ROADHOG_HOOK_PROXIMITY - OW1_ROADHOG_HOOK_PROXIMITY)*directionTowards(victim, attacker), 
#                 null, 
#                 null, 
#                 false).getHitPosition())


rule "[roadhog/hook.opy]: OW1 hook damage":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    damage(
        victim, 
        attacker, 
        (OW1_ROADHOG_HOOK_DAMAGE/OW2_ROADHOG_HOOK_DAMAGE) * eventDamage - eventDamage)
