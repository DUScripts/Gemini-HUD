start:
pitchInput = pitchInput - 1
if buttonC==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(0,0,resMAX/2,resMAX/2) == 1 then
      system.print("CANNON PROFILE: 50%/50%")
      local res = {1,1,1,1}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end