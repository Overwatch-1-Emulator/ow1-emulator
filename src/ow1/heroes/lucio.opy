#!mainFile "../../main.opy"

subroutine initLucio

rule "[lucio.opy]: Detect Lucio initialization":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.call_init == true # without this flag, the reset code in generic.opy executes after initialization

    initLucio()
    eventPlayer.call_init = false


def initLucio():
    @Name "[lucio.opy]: initLucio()"

    removeSelfHealing()


rule "[lucio.opy]: Handle lucio self healing while amp is not active and supp passive is active":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.support_passive_active
    
    eventPlayer.self_healing_percent = percent(OW1_LUCIO_SELF_HEALING /(OW2_LUCIO_SELF_HEALING + OW1_SUPPORT_PASSIVE_HEALING))


rule "[lucio.opy]: Handle lucio self healing while amp is not active and support passive inactive":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2() == false
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.support_passive_active == false

    eventPlayer.self_healing_percent = percent(OW1_LUCIO_SELF_HEALING/OW2_LUCIO_SELF_HEALING)


rule "[lucio.opy]: Handle lucio self when amp is active and supp passive is active":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.support_passive_active

    eventPlayer.self_healing_percent = percent(OW1_LUCIO_AMP_HEALING /(OW1_LUCIO_AMP_HEALING + OW1_SUPPORT_PASSIVE_HEALING))
    
    
rule "[lucio.opy]: Handle lucio self when amp is active and supp passive is inactive":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.support_passive_active == false   
        
    eventPlayer.self_healing_percent = 100


rule "[lucio.opy]: If lucio uses speed aura remove self healing":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.self_healing_percent = 0
