start:
pitchInput = pitchInput - 1
if buttonC==true and shield.getResistancesCooldown() == 0 then
   system.print("CANNON PROFILE: 50%/50%")
   shield.setResistances(0,0,resMAX/2,resMAX/2)
   local res = {1,1,1,1}
   actionRes(res)
end