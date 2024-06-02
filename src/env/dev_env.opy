#!mainFile "../dev_main.opy"

# Environment Variables
#!define GAMEMODE_VERSION "Dev Build"
#!define GAMEMODE_NAME "Overwatch 1++"
#!define GAMDMODE_DESCRIPTION (GAMEMODE_NAME + " " + GAMEMODE_VERSION + "\n" + \
                               "\n" + \
                               "Overwatch 1 Emulator (KHTG0)" + "\n" + \
                               "extended with Overwatch 2 Heroes" + "\n" + \
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
                               "Ciach795#2589" + "\n" + \
                               "\n" + \
                               "workshop.codes/ow1-plus-plus" + "\n" + \
                               "\n" + \
                               "Discord:" + "\n" + \
                               DISCORD_SHORT_LINK + "\n" + \
                               DISCORD_LONG_LINK + "\n" + \
                               "\n" + \
                               "Source code:" + "\n" + \
                               SOURCE_CODE_LINK)
#!define GAMEMODE_CODE "YKMXH"
#!define STAGING_CODE "SXGCQ"
#!define DISCORD_SHORT_LINK "dsc.gg/ow1"
#!define DISCORD_LONG_LINK "discord.gg/GMVqwYXbWB"
#!define SOURCE_CODE_LINK "github.com/Overwatch-1-Emulator/ow1-emulator"

#!define ENABLE_JUNKERQUEEN true
#!define ENABLE_MAUGA true
#!define ENABLE_RAMATTRA true
#!define ENABLE_SOJOURN true
#!define ENABLE_ILLARI true
#!define ENABLE_KIRIKO true
#!define ENABLE_LIFEWEAVER true

rule "Copyright (c) 2024 Overwatch 1 Emulator. See github.com/Overwatch-1-Emulator/ow1-emulator for license to use this code.":
    @Disabled
    disableInspector()
