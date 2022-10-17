-- GEMINI FOUNDATION

-- Many thanks to:
--  W1zard for weapon and radar widgets
--  tiramon for closest pipe functions
--  SeM for the help with the coroutines
--  JayleBreak for planetref functions
--  Aranol for closest pos functions and 2D planet radar
--  Mistery for vector functions
--  Middings for brake distance function
--  IvanGrozny for Echoes widget, 3D space map, icons from his "Epic HUD"
--  Chelobek for target vector widget

-- Gemini HUD is the rebirth of the CFCS HUD (Custom Fire Control System)
-- Author: GeminiX (aka SneakySnake, DU Pirate)

--Remote controller
HUD_version = '1.0.0'

--vars
hudHTML = ''
damageLine = ''
damage = 0
lastDamageTime = 0
maxSHP = 210 --svg shield X right side coordinate
shieldMaxHP = shield.getMaxShieldHitpoints()
HP = math.floor(shield.getShieldHitpoints()/shieldMaxHP * 100)
svghp = maxSHP * (HP * 0.01)
shieldHP = string.format('%0.0f',HP) --formatted shield hp
