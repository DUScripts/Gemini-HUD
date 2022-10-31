Copy the CFCS_HUD folder from the archive and put it in the custom folder, which is located at the following address:

C:\ProgramData\Dual Universe\Game\data\lua\autoconf\custom

Use the numbers of the planets to set up the pipes from the atlas (planet id):
C:\ProgramData\Dual Universe\Game\data\lua\atlas.lua

Link the fuel tank that consumes the most fuel, shield, core, warp engine, screen and databank to the remote controller, then load the configuration to the remote controller.
Link the core, screen, atmo and space radar, weapons to the gunner module, then load the configuration into the gunner module.
Use the current whitelist.lua from the channel #whitelist📄 (put it in the CFCS_HUD folder with replacement)

CFCS_gunner_1_46_2HP.conf - modification to display 2 hit probabilities, where weapon_4 - M laser and weapon_1 - M railguns

Periscope script
Link programming board 1 to manual switch, then paste the periscope-PB configuration.json in programming board 1

Link this manual switch to programming board 2, then paste the periscope-PB-fix configuration.json in programming board 2

The periscope image freezes when the view changes after exiting the ganner interface!
Left alt - zoom picture in the periscope, button G fix/turn on/ off the periscope if the image freezes after changing the view.

DON'T FORGET TO ACTIVATE DRM ON THE SEAT/BOARD/REMOTE

Put the audio folder with sounds in Documents\NQ\DualUniverse\

Features:
1. Target ID on the radar widget for focus, filter allies/enemies/locked targets (ALT+C/ALT+SPACE)
2. Closest pipe
3. Distance to the safe zone/pvp
4. Planetary 2D radar
5. 3D map of the Helios system
6. The ability to add a position to a 3D map, displaying information for the desired position - closest pipe, closest planet and the distance to the safe zone (global and local coordinates are supported).
7. Shield control system, semi-automatic mode with manual confirmation of stress-based resistances and fully automatic mode. Profiles of ready-made shield resistance settings.
8. Notifications about new targets on the radar in the LUA channel: id, name, target size, your local time and your current position (by default, the alert is disabled in the safe zone, but you can enable it).
9. Monitoring the data of all identified targets, monitoring the capture of the enemy, you can determine whether the enemy is shooting at you at the moment or just holding you in lock.
10. Echo radar contacts (for beauty)
11. Color customization and transparency adjustment of some HUD components.
12. Compact widgets for controlling weapons from the 3rd person.
13. The ability to set the pipe manually via LUA parameters using the bodyid from atlas.lua
14. 3 danger levels, red - you are in the pipe, orange - 1su to the nearest pipe, green - more than 1su to the nearest pipe)
Left SHIFT - Help.
Ctrl + space - hold brake.

CFCS - Custom Fire Control System

How the shield system works:
Press the left shift to display hints. At the bottom left, under the amount of fuel, you will see the current shield resistance settings (PW - power).
By default, we have a pool of 60 available points for setting shield resistances. 60 points is 100% of the shield's power.
The left row displays the current shield power settings, the right row displays incoming damage over the last 40 seconds.
You can work with manual and automatic shield mode (AUTO or 50), AUTO mode is enabled by default and the MAX - 100% shield power setting will be set to the maximum damage received in the last 40 seconds.
After the 1st hit on you, the shield panel will open automatically, the panel will hide itself at 5 minutes of combat lock.
If you have not been shot at for 40 seconds, then resists will be applied after 5 shots at you in automatic mode.

In manual mode, you can agree with the system and confirm the installation of the calculated damage values for the last 40 seconds without waiting for the end of the calculation, to do this, press option-6 (works only in manual mode). After you press option-6, you will see an orange timer lasting 60 seconds. After 60 seconds, you can set new shield resistance values again.
The system has 2 modes for setting the resistance power: MAX and 50.

In 50 mode, the shield power will be split in half between the two strongest damage types, in MAX mode 100% of the power will be directed to the greatest incoming damage.
In the automatic shield mode, you do not need to press option-6 to set the values of the shield resistances, the system will do this automatically.
Red timer - cooldown of the ventilation shield.

How to work with the focus mode of enemies:
Send the f command to the LUA chat and the last 3 digits of the ID of the target you need separated by a comma or a space that you want to add to the list for focus. 
Now only the targets we need will be displayed on the radar widget.
To disable focus mode, press C+SPACE or use the res or f commands

The percentages of the shield now change color, a low health notification of the shield is added after 50%, after 35% the notification will flicker. 
Added global status: green - everything is OK, orange - you are locked and red - you are attacked. 
Inside the icon in the middle, the number of targets that have locked you or are attacking you is displayed. Attacking targets in the list on the left will be highlighted in red, the remaining targets in orange.