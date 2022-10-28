start:
rollInput = rollInput + 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
   system.print("THERMIC POWER: 100%")
   shield.setResistances(0,0,0,resMAX)
end
if buttonC==true and shield.getResistancesCooldown() == 0 then
   system.print("MISSILE PROFILE: 50/50%")
   shield.setResistances(resMAX/2,0,resMAX/2,0)
end