start:
rollInput = rollInput - 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(0,0,resMAX,0) == 1 then
      system.print("KINETIC POWER: 100%")
      local res = {0,0,1,0}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end
if buttonC==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(resMAX/2,resMAX/2,0,0) == 1 then
      system.print("RAILGUN PROFILE: 50/50%")
      local res = {1,1,0,0}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end