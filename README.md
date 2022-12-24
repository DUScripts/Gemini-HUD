Gemini Foundation<br/>
Dual Universe PvP HUD<br/>
GHUD is the rebirth of the CFCS HUD (Custom Fire Control System)
## Links:
- Discord: https://discord.gg/sTWdvte8E7<br/>
### Donate:<br/>
You can support me in the game (DAC/quanta)<br/>
IGN: GeminiX<br/>
<br/>
Alternative:<br/>
- ERC20/BEP20: 0x90b865B1e05950826D521B4a0F95597d80b23180<br/>
- BTC: 18HJbJBNeWs4ZZPYQ1hpjYt3BLb8VoiwXA<br/>
## Features:
- Animated shield panel<br/>
- Animated radar contact notifications<br/>
- Animated hit/miss notifications<br/>
- AR sight based on distance to selected target<br/>
- AR planets<br/>
- AR allies marks<br/>
- AR closest pvp/safe zone marks<br/>
- AR asteroid/custom mark<br/>
- Gunner can track multiple identified targets<br/>
- HUD design customization<br/>
- Custom weapon widgets (hit probability, target ID, short ammo name)<br/>
- Custom radar widget (target ID, size filter, pvp focus mode, transponders and whitelist support)<br/>
- Target Vector feature<br/>
- Closest pipe UI<br/>
- Closest pvp/safe zone UI<br/>
- Helios system rotating space map<br/>
- 2D planetary periscope<br/>
- Waypoint info (lua chat: closest pipe, distance to safe zone)<br/>
- Radar contact sound notification<br/>
- Transponder tag can be set via lua chat<br/>
- Closest pipe waypoint<br/>
- Waypoint to custom pipe closest distance<br/>
![image](https://user-images.githubusercontent.com/104208203/209449684-5749201e-5434-4090-8f00-ffa2ee4d3fa1.png)
![HUD1](https://github.com/Crusader93/Gemini-HUD/blob/master/images/1.png)<br/>
![HUD2](https://github.com/Crusader93/Gemini-HUD/blob/master/images/2.png)<br/>
![HUD3](https://github.com/Crusader93/Gemini-HUD/blob/master/images/33.png)<br/>
![HUD4](https://github.com/Crusader93/Gemini-HUD/blob/master/images/cp2.png)<br/>
![HUD5](https://github.com/Crusader93/Gemini-HUD/blob/master/images/3.png)<br/>
## Installation
### .conf files:
1) Download the .conf file(s) you would like to use
2) Place them in your `custom` folder in the DU game path (defaults to here on installation: `ProgramData\Dual Universe\Game\data\lua\autoconf\custom`
3) Update custom scripts in-game or log in if the game is not running
### Gunner module:
Place the space radar on the construct first, then link the `screen`, `2 databanks`, `weapons` (optional), `space radar` and `atmo radar` (2nd radar is optional) to gunner module, then load the configuration to gunner module.<br/>
Put the audio folder with sounds here: `Documents\NQ\DualUniverse\` <br/>
### Remote controller:
Place the transponder on the construct, then link `1 spacefuetank` to remote controller, then load the configuration to remote controller.<br/>
### Pilot seat:
Place the transponder and space radar on the construct first, then link the `screen`, `1 spacefuetank`, `2 databanks`, `weapons` (optional), `space radar` and `atmo radar` (2nd radar is optional) to pilot seat, then load the configuration to gunner module.<br/>
Put the audio folder with sounds here: `Documents\NQ\DualUniverse\` <br/>
### Periscope:
Link `programming board 1` to manual switch, then copy and paste the `programming-board-1.json` to `programming board 1`<br/>
Link manual switch to `programming board 2`, then copy and paste the `programming-board-2.json` to `programming board 2`<br/>
### Periscope controls:
`Alt + MMB`: zoom periscope.<br/>
### HUD controls:
Use `G + ←` or `G + →` to call a helpers.<br/>
I highly recommend you change your game controls: set buttons 1-8 instead of Options 1-8.<br/>
![controls1](https://github.com/Crusader93/Gemini-HUD/blob/master/images/controls.png)<br/>
![controls2](https://github.com/Crusader93/Gemini-HUD/blob/master/images/gunner1.png)<br/>
![controls3](https://github.com/Crusader93/Gemini-HUD/blob/master/images/remote1.png)<br/>
### Shield system:
In auto mode, the shield is calibrated after the first 5 hits on you. If you haven't been hit within 40 seconds, this count will be reset.<br/>
The 50/50 mode splits the pool of available shield power between the two strongest damage types.<br/>
By default, the MAX mode is enabled - the shield power will be used for the strongest type of damage.<br/>
In manual mode, the shield also makes calculations. You can agree with the system in manual mode and apply the new shield resistances by pressing 'option-6'
## Many thanks to:<br/>
 - W1zard for weapon and radar widgets<br/>
 - tiramon for closest pipe functions<br/>
 - DeadRank for brake distance function<br/>
 - SeM for the help with the coroutines<br/>
 - Aranol for closest pos functions and 2D planetary periscope<br/>
 - Mistery for vector functions<br/>
 - IvanGrozny for Echoes widget, 3D space map, icons from his "Epic HUD"<br/>
 - Chelobek for target vector widget<br/>

GHUD 1st shield panel concept:
![example1](https://github.com/Crusader93/Gemini-HUD/blob/master/images/shield.png)<br/>
