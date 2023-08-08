#!mainFile "../../main.opy"

playervar enemy_sombra
playervar friendly_sombra

subroutine initSombra

rule "[sombra.opy]: Detect Sombra initialization":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initSombra()
    eventPlayer.initialized = true


def initSombra():
    @Name "[sombra.opy]: initSombra()"

    getPlayers(eventPlayer.getTeam()).friendly_sombra = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_sombra = eventPlayer


rule "[sombra.opy]: Cancel invis if hack activated":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1()
    @Condition eventPlayer.isFiringSecondaryFire()
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "[sombra.opy]: OW1 hack duration on enemies":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)

    eventPlayer.setStatusEffect(null, Status.HACKED, OW1_SOMBRA_HACK_ENEMY_DURATION)


rule "[sombra.opy]: No damage with EMP":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.getUltCharge() >= 100
    
    waitUntil(eventPlayer.isHoldingButton(Button.ULTIMATE) == true, 9999)
    waitUntil(eventPlayer.getUltCharge() <= 0, 9999)
    eventPlayer.setDamageDealt(0)
    waitUntil(eventPlayer.isUsingUltimate() == true, 9999)
    eventPlayer.setDamageDealt(100)


rule "[sombra.opy]: Deal OW1 machine pistol damage":
    @Event playerDealtDamage
    @Hero sombra
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(OW1_SOMBRA_MACHINE_PISTOL_DAMAGE/OW2_SOMBRA_MACHINE_PISTOL_DAMAGE)-eventDamage)
