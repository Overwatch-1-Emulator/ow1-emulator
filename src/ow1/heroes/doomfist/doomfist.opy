#!mainFile "../../../main.opy"

/*
This DPS doomfist workshop script is heavily based on
https://workshop.codes/dpsdoom        code: ZXJB4
created by discord users: Bebel#5658 and Xponit#1474
*/

# Semi-public scoped variables
playervar is_using_uppercut
playervar is_using_slam

#!include "ow1/heroes/doomfist/uppercut.opy"
#!include "ow1/heroes/doomfist/slam.opy"
#!include "ow1/heroes/doomfist/punch.opy"
#!include "ow1/heroes/doomfist/meteor.opy"
#!include "ow1/heroes/doomfist/cannon.opy"


subroutine initDoomfist

rule "[doomfist.opy]: Detect Doomfist initialization":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.initialized == false # without this flag, the reset code in generic.opy executes after initialization

    initDoomfist()
    eventPlayer.initialized = true


def initDoomfist():
    @Name "[doomfist.opy]: initDoomfist()"

    # Set Doomfist health to OW1
    while (eventPlayer.getMaxHealth() != OW1_DOOMFIST_HEALTH):
        clearCustomHealth()
        setCustomHealth(OW1_DOOMFIST_HEALTH, 0, 0)
        wait(1)

    # Decouple ability button press from trigerring ability
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    
    # Variables for swapping keybinds
    eventPlayer.shift_pressed_by_bot = false
    eventPlayer.e_pressed_by_bot = false

    eventPlayer.punched_victims = []
    eventPlayer.wall_impacted_victims = []

    eventPlayer.setKnockbackReceived(percent(1/(1-OW2_TANK_KNOCKBACK_REDUCTION)))

    # Below variables are also declared and initialized in reset_hero.opy
    getPlayers(eventPlayer.getTeam()).friendly_doomfist_player = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).enemy_doomfist_player = eventPlayer
