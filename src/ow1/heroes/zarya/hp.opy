#!mainFile "../../../main.opy"


rule "[zarya/hp.opy]: Initialize Zarya HP":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    wait(1)
    setCustomHealth(OW1_ZARYA_HEALTH, 0, OW1_ZARYA_SHIELDS)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START
