# #!mainFile "../../dev_main.opy"


# rule "[lifeweaver/init.opy]: Allow self healing during Rejuvanating Dash":
#     @Event eachPlayer
#     @Hero lifeweaver
#     @Condition not eventPlayer.isOnGround()
#     @Condition not eventPlayer.isHoldingButton(Button.JUMP)
#     @Condition eventPlayer.getAbilityCooldown(Button.JUMP) <= 0

#     waitUntil(eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isOnGround(), Math.INFINITY)
#     if eventPlayer.isOnGround():
#         return
    
#     pushSelfHealing(Button.JUMP)
#     # waitUntil(eventPlayer.getAbilityCooldown(Button.JUMP) > 0, Math.INFINITY)
#     wait(0.25)
#     popSelfHealing(Button.JUMP)
