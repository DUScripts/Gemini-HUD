start:
pitchInput = pitchInput - 1
if buttonC==true and shield.getResistancesCooldown() == 0 then
   local resistance = shield.getResistances()
   local res = {0,0,resMAX/2,resMAX/2}
      if resistance[1] ~= res[1] and
      resistance[2] ~= res[2] and
      resistance[3] ~= res[3] and
      resistance[4] ~= res[4] then
   if shield.setResistances(0,0,resMAX/2,resMAX/2) == 1 then
      system.print("CANNON PROFILE: 50%/50%")
      actionRes(res)
      system.playSound('shieldNewResists.mp3')
   else
      system.print("ERR6")
      system.playSound('shieldResistError.mp3')
   end
end
end