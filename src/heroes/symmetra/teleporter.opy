#!mainFile "../../dev_main.opy"


rule "[symmetra/teleporter.opy]: Set default teleporter cooldown":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, OW1_SYMMETRA_TELEPORTER_COOLDOWN_TIME)
