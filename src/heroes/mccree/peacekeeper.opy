#!mainFile "../../dev_main.opy"


rule "[mccree/peacekeeper.opy]: Remove damage reduction during deadeye":
    @Event playerDealtDamage
    @Hero mccree
    @Condition eventWasCriticalHit

    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
