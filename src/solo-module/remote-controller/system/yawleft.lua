start:
yawInput = yawInput + 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
    system.print("ANTIMATTER POWER: 100%")
    shield.setResistances(resMAX,0,0,0)
 end
 if buttonC==true and shield.getResistancesCooldown() == 0 then
    system.print("LASER/CANNON PROFILE: 33%/33%/33%")
    shield.setResistances(0,resMAX/3,resMAX/3,resMAX/3)
 end