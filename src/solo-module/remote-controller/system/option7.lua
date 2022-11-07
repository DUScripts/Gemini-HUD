start:
if lalt==true then
    if GHUD_shield_auto_calibration == true then
       GHUD_shield_auto_calibration = false
       system.print('Shield auto mode deactivated')
    else
       GHUD_shield_auto_calibration = true
       system.print('Shield auto mode activated')
    end
end

if lalt==false then
if GHUD_shield_calibration_max == true then
    GHUD_shield_calibration_max = false
    system.print('Shield max stress mode deactivated')
    system.print('Shield 50/50 activated')
 else
    GHUD_shield_calibration_max = true
    system.print('Shield 50/50 deativated')
    system.print('Shield max stress mode activated')
 end
end

if GHUD_shield_auto_calibration
then
   if GHUD_shield_calibration_max then
      shieldText = "SHIELD (AUTO,MAX)"
   end
   if not GHUD_shield_calibration_max then
      shieldText = "SHIELD (AUTO,50)"
   end
else
   if GHUD_shield_calibration_max then
      shieldText = "SHIELD (MANUAL,MAX)"
   end

   if not GHUD_shield_calibration_max then
      shieldText = "SHIELD (MANUAL,50)"
   end
end