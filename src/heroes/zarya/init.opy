#!mainFile "../../dev_main.opy"

# !include "self_bubble.opy"
# !include "ally_bubble.opy"


def initZarya():
    @Name "[zarya/init.opy]: initZarya()"

    setCustomHp(OW1_ZARYA_HEALTH, 0, OW1_ZARYA_SHIELDS)
    setUltCost(OW1_ZARYA_ULT_COST)
    setBaseDamage(eventPlayer, OW1_ZARYA_CANNON_DAMAGE_MAX/OW2_ZARYA_CANNON_DAMAGE_MAX)
    removeSelfHealing()

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)

    # removeTankPassive()

    # initSelfBubble()
    # initAllyBubble()


rule "[zarya/barrier.opy]: OW1 Zarya self barrier health":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0

    eventPlayer.setMaxHealth(percent(OW1_ZARYA_BARRIER_HEALTH/OW2_ZARYA_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))


rule "[zarya/barrier.opy]: OW1 Zarya ally barrier health":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0

    eventPlayer.setMaxHealth(percent(OW1_ZARYA_BARRIER_HEALTH/OW2_ZARYA_BARRIER_HEALTH))
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(eventPlayer.isUsingAbility2(), 1)
    eventPlayer.setMaxHealth(percent(eventPlayer._hp_scalar))


# rule "[zarya/init.opy]: Initialize Zarya":
#     @Event eachPlayer
#     @Hero zarya
#     @Condition not eventPlayer._is_exiting_wholehog # guards against initialization when exiting wholehog

#     resetHero()
#     async(initZarya, AsyncBehavior.RESTART)


rule "[zarya/init.opy]: Clean up Zarya":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.ZARYA

    waitUntil(eventPlayer.getCurrentHero() != Hero.ZARYA, Math.INFINITY)
    # hideSelfBubbleCD()
    # hideAllyBubbleCD()


rule "[zarya/init.opy]: Compensate zarya global damage reduction":
    @Event playerDealtDamage
    @Hero zarya
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
