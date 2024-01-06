#!mainFile "../../main.opy"


rule "[hanzo/init.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Hero ana

    eventPlayer.call_init = true


rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer.call_init
    
    defaultHero()
    setUltCost(OW1_HANZO_ULT_COST)
    eventPlayer.call_init = false


rule "[hanzo.opy]: Deal OW1 primary fire damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility == Button.PRIMARY_FIRE or\
               eventAbility == Button.ABILITY_1

    damage(victim, attacker, eventDamage*(OW1_HANZO_ARROW_DAMAGE/OW2_HANZO_ARROW_DAMAGE)-eventDamage)


rule "[hanzo.opy]: Deal OW1 storm arrow damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility == Button.ABILITY_2

    damage(victim, attacker, eventDamage*(OW1_HANZO_STORM_DAMAGE/OW2_HANZO_STORM_DAMAGE)-eventDamage)
