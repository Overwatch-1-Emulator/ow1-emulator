#!mainFile "../../dev_main.opy"

playervar rally_pvar
#!defineMember _hp_before_rally rally_pvar[0]
playervar rally_i
playervar rally_armor_ids

#!define getMissingHp() (eventPlayer.getMaxHealth() - eventPlayer.getHealth())
#!define getNaturalArmor() ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
#!define getExtraArmor() (eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())


rule "[brigitte/rally.opy]: Remove OW2 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMaxHealth(percent(0))
    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF)) # 30% movement speed buff during ralley

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []

    eventPlayer._hp_before_rally = eventPlayer.getHealth()
    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    eventPlayer.setHealth(eventPlayer._hp_before_rally)

    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)

    eventPlayer.setMoveSpeed(100)

    wait(OW1_BRIGITTE_RALLY_ARMOR_DURATION)

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []


rule "[brigitte/rally.opy]: Recreate OW1 Rally Armor for self":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()
    @Condition getExtraArmor() < OW1_BRIGITTE_RALLY_ARMOR_MAX

    do:
        eventPlayer.addHealthPool(Health.ARMOR, min(OW1_BRIGITTE_RALLY_ARMOR, (OW1_BRIGITTE_RALLY_ARMOR_MAX - getExtraArmor())), false, false)
        eventPlayer.rally_armor_ids.append(getLastCreatedHealthPool())
        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


rule "[brigitte/rally.opy]: Remove OW2 Rally Ally Overhealth":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) < OW2_BRIGITTE_RALLY_RADIUS
    @Condition isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)

    do:
        damage(eventPlayer, null, OW2_BRIGITTE_RALLY_OVERHEALTH * eventPlayer._base_hp_scalar)
        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION


rule "[brigitte/rally.opy]: Recreate OW1 Rally Armor for ally":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition getExtraArmor() < OW1_BRIGITTE_RALLY_ARMOR_MAX

    do:
        eventPlayer.addHealthPool(Health.ARMOR, min(OW1_BRIGITTE_RALLY_ARMOR, (OW1_BRIGITTE_RALLY_ARMOR_MAX - getExtraArmor())), false, false)
        eventPlayer._friendly_brigitte_player.rally_armor_ids.append(getLastCreatedHealthPool())
        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION
