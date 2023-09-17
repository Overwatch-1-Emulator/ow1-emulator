#!mainFile "../../../main.opy"

rule "[doomfist/hp.opy]: Initialize Doomfist Hp":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.call_init == true

    wait(1)
    setCustomHealth(OW1_DOOMFIST_HEALTH, 0, 0)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START
