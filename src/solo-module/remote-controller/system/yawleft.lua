start:
yawInput = yawInput + 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(resMAX,0,0,0) == 1 then
      system.print("ANTIMATTER POWER: 100%")
      local res = {1,0,0,0}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end
if buttonC==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(0,resMAX/3,resMAX/3,resMAX/3) == 1 then
      system.print("LASER/CANNON PROFILE: 33%/33%/33%")
      local res = {0,1,1,1}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end