@echo off

if exist deathrun.iwd del deathrun.iwd
7za a -tzip deathrun.iwd maps
7za a -tzip deathrun.iwd deathrun_readme.txt

if exist deathrun_images.iwd del deathrun_sounds.iwd
7za a -tzip deathrun_sounds.iwd sound

if exist deathrun_images.iwd del deathrun_images.iwd
7za a -tzip deathrun_images.iwd images

pause