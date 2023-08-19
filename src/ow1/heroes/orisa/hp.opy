#!mainFile "../../../main.opy"

rule "[orisa/hp.opy]: Set Orisa Hp":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.initialized == false

    while (eventPlayer.getMaxHealth() != OW1_ORISA_HEALTH + OW1_ORISA_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
        wait(1)
