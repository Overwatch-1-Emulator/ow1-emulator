#!mainFile "../../../main.opy"


rule "[reinhardt/hp.opy]: Initialize Reinhardt hp":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait(1)
    setCustomHealth(OW1_REINHARDT_HEALTH, OW1_REINHARDT_ARMOR, 0)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START
