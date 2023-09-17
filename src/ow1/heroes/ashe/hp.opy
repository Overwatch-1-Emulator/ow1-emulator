#!mainFile "../../../main.opy"


rule "[ashe.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.call_init == true

    wait(1)
    setCustomHealth(OW1_ASHE_HEALTH, 0, 0)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START
