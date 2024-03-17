#!mainFile "../../dev_main.opy"


# rule "[lucio/aura.opy]: Handle lucio self healing while amp is not active and supp passive is active":
#     @Event eachPlayer
#     @Hero lucio
#     @Condition not eventPlayer.isUsingAbility2()
#     @Condition not eventPlayer.isUsingAbility1()
#     @Condition eventPlayer._passive_healing_active
    
#     eventPlayer._self_healing_percent = percent(OW1_LUCIO_SELF_HEALING /(OW2_LUCIO_SELF_HEALING + OW2_SUPPORT_PASSIVE_HEALING))


# rule "[lucio/aura.opy]: Handle lucio self healing while amp is not active and support passive inactive":
#     @Event eachPlayer
#     @Hero lucio
#     @Condition not eventPlayer.isUsingAbility2()
#     @Condition not eventPlayer.isUsingAbility1()
#     @Condition not eventPlayer._passive_healing_active

#     eventPlayer._self_healing_percent = percent(OW1_LUCIO_SELF_HEALING/OW2_LUCIO_SELF_HEALING)


# rule "[lucio/aura.opy]: Handle lucio self when amp is active and supp passive is active":
#     @Event eachPlayer
#     @Hero lucio
#     @Condition eventPlayer.isUsingAbility2()
#     @Condition not eventPlayer.isUsingAbility1()
#     @Condition eventPlayer._passive_healing_active

#     eventPlayer._self_healing_percent = percent(OW1_LUCIO_AMP_HEALING /(OW1_LUCIO_AMP_HEALING + OW2_SUPPORT_PASSIVE_HEALING))
    
    
# rule "[lucio/aura.opy]: Handle lucio self when amp is active and supp passive is inactive":
#     @Event eachPlayer
#     @Hero lucio
#     @Condition eventPlayer.isUsingAbility2() == true
#     @Condition eventPlayer.isUsingAbility1() == false
#     @Condition eventPlayer._passive_healing_active == false   
        
#     eventPlayer._self_healing_percent = 100


# rule "[lucio/aura.opy]: If lucio uses speed aura remove self healing":
#     @Event eachPlayer
#     @Hero lucio
#     @Condition eventPlayer.isUsingAbility1() == true

#     eventPlayer._self_healing_percent = 0
