Gemini Foundation<br/>
Dual Universe PvP HUD<br/>
## Work in progress
Discord: https://discord.gg/sTWdvte8E7<br/>
<br/>
GHUD is the rebirth of the CFCS HUD (Custom Fire Control System)<br/>
<br/>
Features:<br/>
Animated shield panel<br/>
Animated radar contact notifications<br/>
Animated hit/miss notifications<br/>
AR sight based on distance to selected target<br/>
AR planets<br/>
AR allies marks<br/>
AR closest pvp/safe zone marks<br/>
AR asteroid/custom mark<br/>
Gunner can track multiple identified targets<br/>
HUD design customization<br/>
Custom weapon widgets (hit probability, target ID, short ammo name)<br/>
Custom radar widget (target ID, size filter, pvp focus mode, transponders and whitelist support)<br/>
Target Vector feature<br/>
Closest pipe UI<br/>
Closest pvp/safe zone UI<br/>
Helios system rotating space map<br/>
2D planetary periscope<br/>
Waypoint info (lua chat: closest pipe, distance to safe zone)<br/>
Radar contact sound notification<br/>
Transponder tag can be set via lua chat<br/>
Closest pipe waypoint<br/>
Waypoint to custom pipe closest distance<br/>
<br/>
Many thanks to:<br/>
 W1zard for weapon and radar widgets<br/>
 tiramon for closest pipe functions<br/>
 DeadRank for brake distance function<br/>
 SeM for the help with the coroutines<br/>
 Aranol for closest pos functions and 2D planetary periscope<br/>
 Mistery for vector functions<br/>
 IvanGrozny for Echoes widget, 3D space map, icons from his "Epic HUD"<br/>
 Chelobek for target vector widget<br/>
 <br/>
DONATE:<br/>
ETH/BEP20: 0x90b865B1e05950826D521B4a0F95597d80b23180 <br/>
BTC: 18HJbJBNeWs4ZZPYQ1hpjYt3BLb8VoiwXA <br/>
TRX: TTEiRTWftQXJCu4h31KZThNZpXhPZjVRMp <br/>
![HUD concept1](https://github.com/Crusader93/Gemini-HUD/blob/master/images/1c.png)<br/>
![HUD concept2](https://github.com/Crusader93/Gemini-HUD/blob/master/images/22.png)<br/>
![example1](https://github.com/Crusader93/Gemini-HUD/blob/master/images/3.png)<br/>
<br/>
Install gunner module:<br/>
Link the screen, 2 databanks, weapons and radar to gunner module, then load the configuration to gunner module.<br/>
You must have one shared databank linked with the gunner seat and remote controller. Total 2 databanks. Gunner module - 2 linked databanks, remote controller - 1 linked databank.<br/>
Put the audio folder with sounds here: Documents\NQ\DualUniverse\ <br/>
<br/>
Install remote controller:<br/>
Link the databank and one spacefuetank to remote controller, then load the configuration to remote controller.<br/>
You must have one shared databank linked with the gunner seat and remote controller. Total 2 databanks. Gunner module - 2 linked databanks, remote controller - 1 linked databank.<br/>
<br/>
Install periscope:<br/>
Link programming board 1 to manual switch, then copy and paste the programming-board-1.json to programming board 1<br/>
Link manual switch to programming board 2, then copy and paste the programming-board-2.json to programming board 2<br/>
<br/>
Periscope controls:<br/>
Alt + MMB: zoom periscope.<br/>
<br/>
HUD controls:<br/>
Use G + ↑ or G + ↓ to call a helpers.<br/>
I highly recommend you change your game controls: set buttons 1-8 instead of Options 1-8.<br/>
![controls1](https://github.com/Crusader93/Gemini-HUD/blob/master/images/controls.png)<br/>
![controls2](https://github.com/Crusader93/Gemini-HUD/blob/master/images/gunner.png)<br/>
Fix: Ctrl + shift: lock brake.<br/>
![controls3](https://github.com/Crusader93/Gemini-HUD/blob/master/images/remote.png)<br/>
<br/>
GHUD 1st shield panel concept:<br/>
![example1](https://github.com/Crusader93/Gemini-HUD/blob/master/images/shield.png)<br/>
