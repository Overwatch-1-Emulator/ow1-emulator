#!mainFile "../../../main.opy"


rule "[brigitte/hp.opy]: Initialize Brigitte Hp":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait(1)
    setCustomHealth(OW1_BRIGITTE_HEALTH, OW1_BRIGITTE_ARMOR, 0)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START
