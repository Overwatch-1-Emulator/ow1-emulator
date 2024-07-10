#!mainFile "../../dev_main.opy"

playervar scoped_shot_distance
playervar scoped_damage_base
playervar ow2_scoped_damage_falloff_scalar
playervar ow1_scoped_damage_falloff_scalar
playervar expected_scoped_damage


# Damage falloff derived from Marblr's "How Damage Falloff is Calculated" video: https://youtu.be/VL2VnkNJPpE
#!define OW1WidowmakerN(d) ((d - OW1_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(OW1_WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - OW1_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW2WidowmakerN(d) ((d - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE)/(OW2_WIDOWMAKER_DAMAGE_FALLOFF_END_DISTANCE - OW2_WIDOWMAKER_DAMAGE_FALLOFF_START_DISTANCE))
#!define OW1WidowmakerFalloff(d) ((OW1WidowmakerN(d)) * OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW1WidowmakerN(d)))
#!define OW2WidowmakerFalloff(d) ((OW2WidowmakerN(d)) * OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR + (1 - OW2WidowmakerN(d)))


def initWidowmaker():
    @Name "[widowmaker/init.opy]: initWidowmaker()"

    setCustomHp(OW1_WIDOWMAKER_HEALTH, 0, 0)
    setUltCost(OW1_WIDOWMAKER_ULT_COST)
    removeSelfHealing()





rule "[widowmaker.opy]: Revert sniper damage falloff":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire()
    @Condition eventPlayer.isFiringPrimaryFire()
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.scoped_shot_distance = distance(attacker.getEyePosition(), victim)
    eventPlayer.ow2_scoped_damage_falloff_scalar = OW2WidowmakerFalloff(eventPlayer.scoped_shot_distance)
    # Cap min/max scalar
    if eventPlayer.ow2_scoped_damage_falloff_scalar > 1: # Max damage scalar
        eventPlayer.ow2_scoped_damage_falloff_scalar = 1
    elif eventPlayer.ow2_scoped_damage_falloff_scalar < OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR: # Min damage scalar
        eventPlayer.ow2_scoped_damage_falloff_scalar = OW2_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR

    eventPlayer.scoped_damage_base = eventDamage/eventPlayer.ow2_scoped_damage_falloff_scalar
    
    eventPlayer.ow1_scoped_damage_falloff_scalar = OW1WidowmakerFalloff(eventPlayer.scoped_shot_distance)
    # Cap min/max scalar
    if eventPlayer.ow1_scoped_damage_falloff_scalar > 1: # Max damage scalar
        eventPlayer.ow1_scoped_damage_falloff_scalar = 1
    elif eventPlayer.ow1_scoped_damage_falloff_scalar < OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR: # Min damage scalar
        eventPlayer.ow1_scoped_damage_falloff_scalar = OW1_WIDOWMAKER_DAMAGE_FALLOFF_SCALAR

    eventPlayer.expected_scoped_damage = eventPlayer.scoped_damage_base * eventPlayer.ow1_scoped_damage_falloff_scalar
    damage(victim, attacker, eventPlayer.expected_scoped_damage - eventDamage)
