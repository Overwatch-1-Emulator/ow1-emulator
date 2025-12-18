#!mainFile "../../dev_main.opy"

playervar remech_damage_taken

rule "[dva/hp.opy]: Correct DVa mech health":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()


    wait(0.016) #Wait.ABORT_WHEN_FALSE
    #eventPlayer.remech_damage_taken = eventPlayer.getMaxHealth() - eventPlayer.getHealth()
    clearCustomHp()
    #eventPlayer.setHealth(eventPlayer.getMaxHealth() - eventPlayer.remech_damage_taken)


rule "[dva/hp.opy]: Correct DVa pilot health":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.getMaxHealthOfType(Health.NORMAL) != OW1_DVA_PILOT_HEALTH

    clearCustomHp()
    setCustomHp(OW1_DVA_PILOT_HEALTH, 0, 0)
