if string.sub((text),1,3) == 'tag' then
   setTag(text)
   transponder.deactivate()
   unit.setTimer('tr',2)
end

if text=="helper" then
   if bhelper == false then
      bhelper = true
      system.showHelper(1)
   else
      bhelper = false
      system.showHelper(0)
   end
end

if text == "am" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {resMAX,0,0,0}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(resMAX,0,0,0) == 1 then
         system.print("ANTIMATTER POWER 100%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "em" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {0,resMAX,0,0}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(0,resMAX,0,0) == 1 then
         system.print("ELECTROMAGNETIC POWER 100%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "th" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {0,0,0,resMAX}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(0,0,0,resMAX) == 1 then
         system.print("THERMIC POWER 100%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "ki" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {0,0,resMAX,0}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(0,0,resMAX,0) == 1 then
         system.print("KINETIC POWER 100%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "c" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {0,0,resMAX/2,resMAX/2}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(0,0,resMAX/2,resMAX/2) == 1 then
         system.print("CANNON PROFILE 50/50%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "r" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {resMAX/2,resMAX/2,0,0}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(resMAX/2,resMAX/2,0,0) == 1 then
         system.print("RAILGUN PROFILE 50/50%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "m" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {resMAX/2,0,resMAX/2,0}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(resMAX/2,0,resMAX/2,0) == 1 then
         system.print("MISSILE PROFILE 50/50%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "u" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {resMAX/4,resMAX/4,resMAX/4,resMAX/4}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(resMAX/4,resMAX/4,resMAX/4,resMAX/4) == 1 then
         system.print("UNIVERSAL PROFILE 25/25/25/25%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text == "l" and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {0,resMAX/2,0,resMAX/2}
   if resistance[1] ~= res[1] or
   resistance[2] ~= res[2] or
   resistance[3] ~= res[3] or
   resistance[4] ~= res[4] then
      if shield.setResistances(0,resMAX/2,0,resMAX/2) == 1 then
         system.print("LASER PROFILE 50/50%")
         actionRes(res)
         system.playSound('shieldNewResists.mp3')
      else
         system.print("ERR6")
         system.playSound('shieldResistError.mp3')
      end
   else
      system.print("ERR7")
      system.playSound('shieldResistError.mp3')
   end
end

if text =="drop" then
   local listships = construct.getDockedConstructs()
   for i=1, #listships do
      construct.forceUndock(listships[i])
   end
   system.print("All ships were successfully undocked")
end

if string.find (text,'m::pos') then
   asteroidPOS = text:sub(2)
   system.print(asteroidPOS)
   system.print('Calculation...')
   asteroidcoord = zeroConvertToWorldCoordinates(asteroidPOS)
   databank_1.setStringValue(15,asteroidPOS)
   corTime = system.getArkTime() 
   ck = coroutine.create(closestPipe1)
   corpos = true
end

local count = #string.gsub(text, "[^f]", "")
local f1 = string.sub(text,1,1)
if count == 1 and f1 == "f" then
   mRadar:onTextInput(text)
end

if text == "export" then GEAR(unit,system,text) end

if text == "clear" then
   databank_2.clear()
   GHUD_friendly_IDs = {}
   newWhitelist = checkWhitelist()
   whitelist = newWhitelist
   system.print('Databank whitelist cleared')
end

if text == "addall" then
   local keys = databank_2.getNbKeys()
   local keyCount = keys
for k,v in pairs(radarIDs) do
    keyCount = keyCount + 1
    databank_2.setIntValue(keyCount,v)
    table.insert(GHUD_friendly_IDs,v)
 end
 newWhitelist = checkWhitelist()
 whitelist = newWhitelist
 system.print('All targets have been added to the whitelist')
end

if text == "friends" then
if GHUD_show_AR_allies_marks == true then
   GHUD_show_AR_allies_marks = false
   system.print('AR allies marks deactivated')
else
   GHUD_show_AR_allies_marks = true
   system.print('AR allies marks activated')
end
end

if text == "safe" then
   if GHUD_safeNotifications == true then
      GHUD_safeNotifications = false
      system.print('Radar safe zone notifications OFF')
   else
      GHUD_safeNotifications = true
      system.print('Radar safe zone notifications ON')
   end
   end

inTEXT(unit,system,text)