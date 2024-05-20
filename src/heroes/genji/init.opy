#!mainFile "../../dev_main.opy"


rule "[genji/init.opy]: Initialize Genji":
    @Event eachPlayer
    @Condition eventPlayer._hero_setup == Hero.GENJI
    @Condition eventPlayer._call_init
    
    setCustomHp(OW1_GENJI_HEALTH, 0, 0)
    setUltCost(OW1_GENJI_ULT_COST)
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)
    
    removeSelfHealing()

    eventPlayer._call_init = false


rule "[genji/init.opy]: Deal OW1 shuriken damage":
    @Event playerDealtDamage
    @Condition eventPlayer._hero_setup == Hero.GENJI
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    damage(victim, attacker, eventDamage*(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE)-eventDamage)