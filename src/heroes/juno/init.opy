#!mainFile "../../main.opy"


def initJuno():
    @Name "[juno/init.opy]: initJuno()"

    setCustomHp(OW1_JUNO_HEALTH, 0, OW1_JUNO_SHIELDS)
    setUltCost(OW1_JUNO_ULT_COST)

    setBaseDamage(eventPlayer, 200/225)
