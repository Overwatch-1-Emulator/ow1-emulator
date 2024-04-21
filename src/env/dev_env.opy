#!mainFile "../dev_main.opy"

# Environment Variables
#!define GAMEMODE_VERSION "Dev Build"
#!define GAMEMODE_NAME "6v6 Adjustments"
#!define GAMDMODE_DESCRIPTION ("Intended for 6v6 gameplay, by Toastie#11770" + "\n" + \
                               "\n" + \
                               "Primary workshop development provided" + "\n" + \
                               "by LemonHead#11820" + "\n" + \
                               "\n" + \
                               "Gamemode originally forked from" + "\n" + \
                               "Overwatch 1 Emulator v1.12.2 (KHTG0)" + "\n" + \
                               "\n" + \
                               "Come join the discord server! We host 6v6" + "\n" + \
                               "custom lobbies every weekend! (6v6.info)" + "\n" + \
                               "https://discord.gg/uzFUQu7G4s")
#!define GAMEMODE_CODE "7HSKW"
#!define DEV_CODE ""
#!define DISCORD_SHORT_LINK "dsc.gg/todo"
#!define DISCORD_LONG_LINK "discord.gg/todo"
#!define SOURCE_CODE_LINK "github.com/6v6-Adjustments/6v6-adjustments"

rule "Copyright (c) 2024 Overwatch 1 Emulator & 6v6 Adjustments. See github.com/6v6-Adjustments/6v6-adjustments for license to use this code.":
    @Disabled
    disableInspector()
