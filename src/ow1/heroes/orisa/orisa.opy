#!mainFile "../../../main.opy"

#!include "ow1/heroes/orisa/supercharger.opy"
#!include "ow1/heroes/orisa/halt.opy"
#!include "ow1/heroes/orisa/protective_barrier.opy"
#!include "ow1/heroes/orisa/ammo.opy"
#!include "ow1/heroes/orisa/fortify.opy"

subroutine initOrisa

rule "[orisa.opy]: Detect Orisa initialization":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initOrisa()
    eventPlayer.initialized = true


def initOrisa():
    @Name "[orisa.opy]: initOrisa()"

    while (eventPlayer.getMaxHealth() != OW1_ORISA_HEALTH + OW1_ORISA_ARMOR):
        clearCustomHealth()
        setCustomHealth(OW1_ORISA_HEALTH, OW1_ORISA_ARMOR, 0)
        wait(1)

    eventPlayer.disallowButton(Button.SECONDARY_FIRE) # Disable OW2 Javelin
    eventPlayer.disallowButton(Button.ABILITY_2) # Disable OW2 Javelin Spin
    eventPlayer.disallowButton(Button.ULTIMATE) # Disable Terra Surge

    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_orisa_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_orisa_player = eventPlayer

    replanishAmmo()
    eventPlayer.setMaxAmmo(0, eventPlayer.current_ammo_count)
    
    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))

    eventPlayer.is_using_supercharger = false
    eventPlayer.is_using_halt = false
