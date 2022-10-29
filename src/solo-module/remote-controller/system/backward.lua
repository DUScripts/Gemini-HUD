start:
pitchInput = pitchInput + 1
if buttonC==true and shield.getResistancesCooldown() == 0 then
   system.print("UNIVERSAL PROFILE: 25%/25%/25%/25%")
   shield.setResistances(resMAX/4,resMAX/4,resMAX/4,resMAX/4)
   local res = {1,1,1,1}
   actionRes(res)
end