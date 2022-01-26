@echo off

set moddir=%cd%

set modname="deathrun_dev"
for /f "delims=" %%A in ('cd') do (
    set modname=%%~nxA
)

cd /d %LocalAppData%\Plutonium\storage\iw5\
if ERRORLEVEL 1 echo "Could not find Plutonium appdata folder..." & goto EOF

if not exist "mods\" (
    mkdir mods
)
cd mods\

if not exist "%modname%\" (
    mkdir %modname%
)
cd %modname%\

xcopy "%moddir%\mod.ff" "%cd%" /YF
xcopy "%moddir%\deathrun.iwd" "%cd%" /YF
xcopy "%moddir%\deathrun_images.iwd" "%cd%" /YF
xcopy "%moddir%\deathrun_sounds.iwd" "%cd%" /YF

:EOF
pause