@echo off

cd ..\..
set "game_folder=%cd%"

set "map=mp_deathrun_gold"
set /p "map=Enter map name or press [ENTER] for default [%map%]: "

cd /d %LocalAppData%\Plutonium
start .\bin\plutonium-bootstrapper-win32.exe iw5mp "%game_folder%" -lan +set name "quaK" +set fs_game "mods\deathrun_dev" +set g_gametype "deathrun" +set developer 2 +set developer_script 1 +map %map%