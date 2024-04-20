#!mainFile "../../main.opy"

playervar remech_damage_taken

rule "[dva/hp.opy]: Correct DVa mech health":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()
    @Condition not eventPlayer.call_init

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.remech_damage_taken = eventPlayer.getMaxHealth() - eventPlayer.getHealth()
    setCustomHp(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
    eventPlayer.setHealth(eventPlayer.getMaxHealth() - eventPlayer.remech_damage_taken)


rule "[dva/hp.opy]: Correct DVa pilot health":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()
    @Condition eventPlayer.getMaxHealthOfType(Health.NORMAL) != OW1_DVA_PILOT_HEALTH
    @Condition not eventPlayer.call_init

    clearCustomHp()
    setCustomHp(OW1_DVA_PILOT_HEALTH, 0, 0)
