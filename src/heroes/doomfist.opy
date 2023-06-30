#!include "ow2_constants.opy"


rule "Doom shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) == 100
    
    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, 9999)


rule "Doom shields":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.getHealthOfType(Health.SHIELDS) < 100
    
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)


rule "Speed":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    
    victim.setMoveSpeed(95)
    wait(2.5)
    victim.setMoveSpeed(100)


rule "Knockback":
    @Event eachPlayer
    @Hero doomfist
    @Condition isGameInProgress() == true
    
    eventPlayer.setKnockbackReceived(130)


rule "More Knockback":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.applyImpulse(Vector.DOWN, 10, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.45)


rule "Upper cut":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.applyImpulse(Vector.UP, 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getPlayersInRadius(eventPlayer, 5, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).applyImpulse(Vector.UP, 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    #getPlayersInRadius(eventPlayer, 5, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).setStatusEffect(eventPlayer, Status.STUNNED, 1.25)
    damage(getPlayersInRadius(eventPlayer, 5, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF), eventPlayer, 50)
    getPlayersInRadius(eventPlayer, 5, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).setMoveSpeed(0)
    eventPlayer.cancelPrimaryAction()
    wait(0.95)
    eventPlayer.setGravity(0)
    getPlayersInRadius(eventPlayer, 5, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).setStatusEffect(eventPlayer, Status.ROOTED, 0.6)
    getPlayersInRadius(eventPlayer, 5, getOppositeTeam(eventPlayer.getTeam()), LosCheck.OFF).setGravity(0)
    wait(0.6)
    getAllPlayers().setGravity(100)
    getAllPlayers().setMoveSpeed(100)


rule "DOOMS FIST":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setDamageDealt(370)
    wait(0.15)
    eventPlayer.setDamageDealt(370)
    wait(0.15)


rule "DOOMS FIST":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isFiringSecondaryFire() == false
    
    eventPlayer.setDamageDealt(100)


rule "Sismic":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setDamageDealt(50)
    hudHeader(eventPlayer, "[25]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setDamageDealt(100)
    destroyHudText(getLastCreatedText())
    hudHeader(eventPlayer, "[50]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setDamageDealt(150)
    destroyHudText(getLastCreatedText())
    hudHeader(eventPlayer, "[75]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setDamageDealt(200)
    destroyHudText(getLastCreatedText())
    hudHeader(eventPlayer, "[100]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    wait(0.25, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setDamageDealt(250)
    destroyHudText(getLastCreatedText())
    hudHeader(eventPlayer, "[125]", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Slam":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingAbility1() == false
    
    eventPlayer.setDamageDealt(100)
    destroyAllHudTexts()
    destroyAllHudTexts()
    wait(0.25)
    destroyAllHudTexts()
    wait(0.25)
    destroyAllHudTexts()
    wait(0.25)
    destroyAllHudTexts()
    wait(0.25)
    destroyAllHudTexts()
    wait(0.25)
    destroyAllHudTexts()
    wait(0.25)
    destroyAllHudTexts()






 
    
