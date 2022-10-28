start:
pitchInput = pitchInput + 1
if buttonC==true and shield.getResistancesCooldown() == 0 then
   system.print("UNIVERSAL PROFILE: 25%/25%/25%/25%")
   shield.setResistances(resMAX/4,resMAX/4,resMAX/4,resMAX/4)
end
if buttonSpace==true then
   if GHUD_shield_auto_calibration == true then
      GHUD_shield_auto_calibration = false
   else
      GHUD_shield_auto_calibration = true
   end
end