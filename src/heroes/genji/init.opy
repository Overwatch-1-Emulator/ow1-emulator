#!mainFile "../../main.opy"


rule "[genji/init.opy]: Detect switch to Genji":
    @Event eachPlayer
    @Hero genji

    eventPlayer.call_init = true


rule "[genji/init.opy]: Initialize Genji":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.call_init
    
    newHero(OW1_GENJI_HEALTH, 0, 0)
    setUltCost(OW1_GENJI_ULT_COST)
    eventPlayer.setAmmo(0, OW1_GENJI_CLIP_SIZE)
    eventPlayer.setMaxAmmo(0, OW1_GENJI_CLIP_SIZE)
    
    removeSelfHealing()

    eventPlayer.call_init = false


rule "[genji.opy]: Deal OW1 shuriken damage":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE]

    damage(victim, attacker, eventDamage*(OW1_GENJI_SHURIKEN_DAMAGE/OW2_GENJI_SHURIKEN_DAMAGE)-eventDamage)