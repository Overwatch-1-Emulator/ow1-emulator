#!mainFile "../../../main.opy"

playervar current_ammo_count

subroutine replanishAmmo

rule "[orisa/halt.opy]: Disable OW2 Javelin":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.call_init == true

    replanishAmmo()
    eventPlayer.setMaxAmmo(0, eventPlayer.current_ammo_count)

rule "[orisa/ammo.opy]: Save ammo count when finished firing":
    @Event eachPlayer
    @Hero orisa
    @Condition not eventPlayer.isFiringPrimaryFire()

    eventPlayer.current_ammo_count = eventPlayer.getAmmo(0)


rule "[orisa/ammo.opy]: Correct ammo count when wrong":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.current_ammo_count != eventPlayer.getAmmo(0)

    eventPlayer.setAmmo(0, eventPlayer.current_ammo_count)


rule "[orisa/ammo.opy]: Replanish ammo on reload":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isReloading()

    replanishAmmo()


def replanishAmmo():
    @Name "[orisa/ammo.opy]: replanishAmmo()"

    eventPlayer.current_ammo_count = OW1_ORISA_AMMO/OW1_ORISA_FIRE_RATE*OW2_ORISA_FIRE_RATE
    eventPlayer.setAmmo(0, eventPlayer.current_ammo_count)