start:
yawInput = yawInput - 1
if buttonSpace==true and shield.getResistancesCooldown() == 0 then
    system.print("ELECTROMAGNETIC POWER: 100%")
    shield.setResistances(0,resMAX,0,0)
 end
 if buttonC==true and shield.getResistancesCooldown() == 0 then
    system.print("LASER PROFILE: 50%/50%")
    shield.setResistances(0,resMAX/2,0,resMAX/2)
 end