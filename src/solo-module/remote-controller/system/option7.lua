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
            shieldText = "MAX - SHIELD"
            shieldIcon = "A"
         end
         if not GHUD_shield_calibration_max then
            shieldText = "50/50 - SHIELD"
            shieldIcon = "A"
         end
      else
         if GHUD_shield_calibration_max then
            shieldText = "MAX - SHIELD"
            shieldIcon = "M"
         end

         if not GHUD_shield_calibration_max then
            shieldText = "50/50 - SHIELD"
            shieldIcon = "M"
         end
      end