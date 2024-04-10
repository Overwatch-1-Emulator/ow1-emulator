#!mainFile "../1v1_main.opy"

# Environment Variables
#!define GAMEMODE_VERSION "Internal Build"
#!define GAMEMODE_NAME "1v1 Arena - Overwatch 1 Edition"
#!define GAMDMODE_DESCRIPTION (GAMEMODE_NAME + " " + GAMEMODE_VERSION + "\n" + \
                               "\n" + \
                               "Seita's 1v1 Arena (TXCXX)"  + "\n" + \
                               "with Overwatch 1 heroes (KHTG0)" + "\n" + \
                               "\n" + \
                               "Latest build: " + GAMEMODE_CODE + "\n" + \
                               "\n" + \
                               "Discord:" + "\n" + \
                               DISCORD_SHORT_LINK + "\n" + \
                               DISCORD_LONG_LINK + "\n" + \
                               "\n" + \
                               "Source code:" + "\n" + \
                               SOURCE_CODE_LINK)
#!define GAMEMODE_CODE "AA69C"
#!define STAGING_CODE "AA69C"
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
