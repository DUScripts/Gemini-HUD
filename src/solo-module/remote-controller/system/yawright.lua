start:
yawInput = yawInput - 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(0,resMAX,0,0) == 1 then
      system.print("ELECTROMAGNETIC POWER: 100%")
      local res = {0,1,0,0}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end
if buttonC==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(0,resMAX/2,0,resMAX/2) == 1 then
      system.print("LASER PROFILE: 50%/50%")
      local res = {0,1,0,01}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end