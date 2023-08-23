#!mainFile "../../../main.opy"

playervar orisa_ammo


rule "orisa ammo":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isFiringPrimaryFire() == true
    
    eventPlayer.orisa_ammo -= 0.5
    eventPlayer.setAmmo(0, eventPlayer.orisa_ammo)
    wait(0.09, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START


rule "orisa keep ammo":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isFiringPrimaryFire() != true
    @Condition eventPlayer.orisa_ammo > 1
    
    eventPlayer.setAmmo(0, eventPlayer.orisa_ammo)
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if RULE_CONDITION:
        goto RULE_START


rule "reloading reset ammo":
    @Event eachPlayer
    @Hero orisa
    @Condition (eventPlayer.isReloading() or eventPlayer.orisa_ammo <= 1) == true
    
    wait(3)
    eventPlayer.orisa_ammo = 50


rule "manual reload":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.orisa_ammo < 50
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    eventPlayer.orisa_ammo = 0
    eventPlayer.setAmmo(0, 0)
