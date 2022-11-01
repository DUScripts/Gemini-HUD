start:
pitchInput = pitchInput + 1
if buttonC==true and shield.getResistancesCooldown() == 0 then
   if shield.setResistances(resMAX/4,resMAX/4,resMAX/4,resMAX/4) == 1 then
      system.print("UNIVERSAL PROFILE: 25%/25%/25%/25%")
      local res = {1,1,1,1}
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end