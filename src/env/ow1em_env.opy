#!mainFile "../ow1em_main.opy"

# Environment Variables
#!define GAMEMODE_VERSION "Internal Build"
#!define GAMEMODE_NAME "Overwatch 1 Emulator"
#!define GAMDMODE_DESCRIPTION (GAMEMODE_NAME + " " + GAMEMODE_VERSION + "\n" + \
                               "\n" + \
                               "ecksdee#11729's attempt to accurately recreate " + "\n" + \
                               "the last version of Overwatch 1 using workshop." + "\n" + \
                               "\n" + \
                               "Check out Overwatch 1++ (YKMXH)" + "\n" + \
                               "to enable Overwatch 2 heroes" + "\n" + \
                               "\n" + \
                               "Stable build: " + GAMEMODE_CODE + "\n" + \
                               "Latest build: " + STAGING_CODE + "\n" + \
                               "\n" + \
                               "Codebase Contributors:" + "\n" + \
                               "ecksdee#11729" + "\n" + \
                               "Snappy#11809" + "\n" + \
                               "KingDonMike#2694" + "\n" + \
                               "thenova#21104" + "\n" + \
                               "pretz#11551" + "\n" + \
                               "Hikigaeru#11863" + "\n" + \
                               "\n" + \
                               "workshop.codes/ow1-emulator" + "\n" + \
                               "\n" + \
                               "Discord:" + "\n" + \
                               DISCORD_SHORT_LINK + "\n" + \
                               DISCORD_LONG_LINK + "\n" + \
                               "\n" + \
                               "Source code:" + "\n" + \
                               SOURCE_CODE_LINK)
#!define GAMEMODE_CODE "KHTG0"
#!define STAGING_CODE "ESMXJ"
#!define DISCORD_SHORT_LINK "dsc.gg/ow1"
#!define DISCORD_LONG_LINK "discord.gg/GMVqwYXbWB"
#!define SOURCE_CODE_LINK "github.com/Overwatch-1-Emulator/ow1-emulator"

#!define ENABLE_JUNKERQUEEN false
#!define ENABLE_MAUGA false
#!define ENABLE_RAMATTRA false
#!define ENABLE_SOJOURN false
#!define ENABLE_ILLARI false
#!define ENABLE_KIRIKO false
#!define ENABLE_LIFEWEAVER false

rule "Copyright (c) 2024 Overwatch 1 Emulator. See github.com/Overwatch-1-Emulator/ow1-emulator for license to use this code.":
    disableInspector()
