#!mainFile "../../main.opy"


rule "[genji.opy]: Initialize Genji":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization


    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)


rule "[genji.opy]: Deal OW1 shuriken damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.PRIMARY_FIRE or eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE)-eventDamage)