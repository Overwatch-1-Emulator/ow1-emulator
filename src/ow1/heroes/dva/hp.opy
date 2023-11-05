#!mainFile "../../../main.opy"

playervar remech_damage_taken

rule "[dva/hp.opy]: Correct DVa mech health":
    @Event eachPlayer
    @Hero dva
    @Condition not eventPlayer.isInAlternateForm()

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.remech_damage_taken = eventPlayer.getMaxHealth() - eventPlayer.getHealth()
    setCustomHealth(OW1_DVA_HEALTH, OW1_DVA_ARMOR, 0)
    damage(eventPlayer, null, eventPlayer.remech_damage_taken)


rule "[dva/hp.opy]: Correct DVa pilot health":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm()

    clearCustomHealth()
