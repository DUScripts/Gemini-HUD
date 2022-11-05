start:
rollInput = rollInput + 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {0,0,0,resMAX}
      if resistance[1] ~= res[1] and
      resistance[2] ~= res[2] and
      resistance[3] ~= res[3] and
      resistance[4] ~= res[4] then
   if shield.setResistances(0,0,0,resMAX) == 1 then
      system.print("THERMIC POWER: 100%")
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end
end
if buttonC==true and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {resMAX/2,0,resMAX/2,0}
      if resistance[1] ~= res[1] and
      resistance[2] ~= res[2] and
      resistance[3] ~= res[3] and
      resistance[4] ~= res[4] then
   if shield.setResistances(resMAX/2,0,resMAX/2,0) == 1 then
      system.print("MISSILE PROFILE: 50/50%")
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end
end