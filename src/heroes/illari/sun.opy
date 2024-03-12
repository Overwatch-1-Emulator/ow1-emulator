#!mainFile "../../main.opy"


rule "[illari/sun.opy]: OW1 Illari Captive Sun damage":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.isUsingUltimate()

    eventPlayer.setDamageDealt(percent(OW1_ILLARI_CAPTIVE_SUN_DAMAGE/OW2_ILLARI_CAPTIVE_SUN_DAMAGE))
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.setDamageDealt(percent(eventPlayer._base_damage_scalar))
