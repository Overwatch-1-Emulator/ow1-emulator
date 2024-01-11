#!mainFile "../../main.opy"


rule "[sombra/emp.opy]: No damage with EMP":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getUltCharge() >= 100
    
    waitUntil(eventPlayer.isHoldingButton(Button.ULTIMATE), Math.INFINITY)
    waitUntil(eventPlayer.getUltCharge() <= 0, Math.INFINITY)
    eventPlayer.setDamageDealt(0.01)
    waitUntil(eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(100)
