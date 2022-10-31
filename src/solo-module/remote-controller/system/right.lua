start:
rollInput = rollInput + 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
   system.print("THERMIC POWER: 100%")
   shield.setResistances(0,0,0,resMAX)
   local res = {0,0,0,1}
   actionRes(res)
   system.playSound('shieldNewResists.mp3')
end
if buttonC==true and shield.getResistancesCooldown() == 0 then
   system.print("MISSILE PROFILE: 50/50%")
   shield.setResistances(resMAX/2,0,resMAX/2,0)
   local res = {1,0,1,0}
   actionRes(res)
   system.playSound('shieldNewResists.mp3')
end