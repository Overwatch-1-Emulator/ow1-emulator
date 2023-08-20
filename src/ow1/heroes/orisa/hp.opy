#!mainFile "../../../main.opy"

rule "[orisa/hp.opy]: Initialize Orisa Hp":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init == true

    while (eventPlayer.getMaxHealth() != OW1_ORISA_HEALTH + OW1_ORISA_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
        wait(1)
