#!mainFile "../../main.opy"

playervar rally_pvar
#!defineMember _hp_before_rally     rally_pvar[0]
#!defineMember _rally_stored_armor  rally_pvar[1]
#!defineMember _rally_armor_added   rally_pvar[2]
playervar rally_i
playervar rally_armor_ids
playervar brig_self_armor_id

#!define getMissingHp() (eventPlayer.getMaxHealth() - eventPlayer.getHealth())
#!define getNaturalArmor() ((eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR)) - eventPlayer.getHealthOfType(Health.NORMAL) - getMissingHp())
#!define getExtraArmor() max(0, eventPlayer.getHealthOfType(Health.ARMOR) - getNaturalArmor())


rule "[brigitte/rally.opy]: Remove OW2 Rally":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setMoveSpeed(percent(OW1_BRIGITTE_RALLY_SPEED_BUFF/OW2_BRIGITTE_RALLY_SPEED_BUFF))

    for eventPlayer.rally_i in range(len(eventPlayer.rally_armor_ids)):
        removeHealthPool(eventPlayer.rally_armor_ids[eventPlayer.rally_i])
    eventPlayer.rally_armor_ids = []

    clearCustomHp()
    setCustomHp(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)

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


rule "[brigitte/rally.opy]: Reset ally tracker when Rally ends":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition not eventPlayer._friendly_brigitte_player.isUsingUltimate()

    eventPlayer._rally_armor_added = 0


rule "[brigitte/rally.opy]: Remove OW2 Rally Ally Overhealth":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) < OW2_BRIGITTE_RALLY_RADIUS
    @Condition isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)

    do:
        # 1. Store only the Rally armor we added, not natural armor
        eventPlayer._rally_stored_armor = eventPlayer._rally_armor_added

        # 2. Remove our Rally armor pool so setHealth doesnt eat it
        for eventPlayer.rally_i in range(len(eventPlayer._friendly_brigitte_player.rally_armor_ids)):
            removeHealthPool(eventPlayer._friendly_brigitte_player.rally_armor_ids[eventPlayer.rally_i])
        eventPlayer._friendly_brigitte_player.rally_armor_ids = []

        # 3. Set health to strip overhealth - rally armor pools removed so
        #    getMaxHealthOfType values now reflect only base HP
        eventPlayer.setHealth(eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS))

        # 4. Add ONLY the Rally armor back capped at OW1_BRIGITTE_RALLY_ARMOR_MAX
        eventPlayer._rally_stored_armor = min(eventPlayer._rally_stored_armor + OW1_BRIGITTE_RALLY_ARMOR, OW1_BRIGITTE_RALLY_ARMOR_MAX)
        if eventPlayer._rally_stored_armor > 0:
            eventPlayer.addHealthPool(Health.ARMOR, eventPlayer._rally_stored_armor, false, false)
            eventPlayer._friendly_brigitte_player.rally_armor_ids.append(getLastCreatedHealthPool())
            eventPlayer._rally_armor_added = eventPlayer._rally_stored_armor

        wait(OW1_BRIGITTE_RALLY_ARMOR_PERIOD, Wait.ABORT_WHEN_FALSE)
    while RULE_CONDITION




rule "[brigitte/rally.opy]: Strip OW2 overhealth from ally every tick":
    @Event eachPlayer
    @Condition eventPlayer != eventPlayer._friendly_brigitte_player
    @Condition eventPlayer._friendly_brigitte_player.isUsingUltimate()
    @Condition distance(eventPlayer, eventPlayer._friendly_brigitte_player) < OW2_BRIGITTE_RALLY_RADIUS
    @Condition isInLoS(eventPlayer, eventPlayer._friendly_brigitte_player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS)
    @Condition eventPlayer.getHealth() > eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS)

    # Armor pools are present here so getMaxHealthOfType(ARMOR) includes Rally
    # armor. Anything above the sum is purely OW2 overhealth. Strip it.
    eventPlayer.setHealth(eventPlayer.getMaxHealthOfType(Health.NORMAL) + eventPlayer.getMaxHealthOfType(Health.ARMOR) + eventPlayer.getMaxHealthOfType(Health.SHIELDS))

    if RULE_CONDITION: goto RULE_START
