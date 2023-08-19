#!mainFile "../../../main.opy"

rule "[fortify.opy]: Remove overhealth during fortify":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingAbility1()

    damage(eventPlayer, null, OW2_ORISA_FORTIFY_OVERHEALTH/OW2_ORISA_FORTIFY_DAMAGE_REDUCTION)
