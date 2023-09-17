#!mainFile "../../../main.opy"

rule "[orisa/hp.opy]: Initialize Orisa Hp":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init == true

    wait(1)
    setCustomHealth(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
    if eventPlayer.getMaxHealth() != (eventPlayer.hp_health + eventPlayer.hp_armor + eventPlayer.hp_shields):
        clearCustomHealth()
        goto RULE_START
