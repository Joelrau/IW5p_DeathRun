# Pluto IW5 Deathrun Mod

## Building
Prenotes: Whereas "MW3_Root", you should be aware it is the root directory of your mw3 installation. <br>

1. Clone the repo to "MW3_Root/mods" folder <br>
2. Copy "zonetool/ZoneTool-x86-release.dll" to "MW3_Root" and rename it to "zonetool.dll" <br>
3. Open "zonetool/zonetool-binaries-master.zip/zonetool-binaries-master" and copy "zonetool_iw5.exe" to "MW3_Root" and rename it to "zonetool.exe" <br>
4. Run makeMod.bat to build mod.ff <br>
5. Run makeIWD.bat to build .iwd files <br>
6. ~~[optional] Run runMod.bat to launch your newly compiled mod, you can change launch options (ex. map) by directly editing .bat file~~ <br>

## Usage

When you wanna use the mod on your server, copy these files to your new mod folder: `*.iwd`(all of the .iwd files), `mod.ff`, `gsc` and `plugins` <br>
