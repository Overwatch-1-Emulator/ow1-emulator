#!mainFile "../../dev_main.opy"

#!define OW1_ROADHOG_SCRAP_SECONDARY_SPEED 80
#!define OW1_ROADHOG_SCRAP_SECONDARY_RANGE 8
# 10 degrees from the axis of the cone
#!define OW1_ROADHOG_SCRAP_CONE_ANGLE 15
#!define OW1_ROADHOG_SCRAP_DAMAGE 250
# Determines how scrap damage scales with distance
# value of 0.5 = 1/x^0.5, 1 = 1/x, 2 = 1/x^2
#!define OW1_ROADHOG_SCRAP_DECAY 1
#!define OW1_ROADHOG_SCRAP_RECOVERY_TIME 1

playervar scrap_gun_pvar
#!defineMember _scrap_detonation_pos scrap_gun_pvar[0]
#!defineMember _detonation_gui scrap_gun_pvar[1]
#!defineMember _scrap_enemies scrap_gun_pvar[2]
#!defineMember _scrap_orientation scrap_gun_pvar[3]
#!defineMember _scrap_last_fire_time scrap_gun_pvar[4]
#!defineMember _scrap_start_pos scrap_gun_pvar[5]
playervar scrap_i



#rule "[roadhog/scrap_gun.opy]: Record last time scrap gun fired":
    #@Event eachPlayer
    #@Hero roadhog
    #@Condition eventPlayer.isFiringPrimaryFire()

    #eventPlayer._scrap_last_fire_time = getTotalTimeElapsed()
