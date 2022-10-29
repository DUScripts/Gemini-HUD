local shield_hp = shield.getShieldHitpoints()
if shield_hp < last_shield_hp then
   HP = shield_hp/shieldMaxHP * 100
   --formatted_hp = string.format('%0.0f',math.ceil(HP))
   local hit = last_shield_hp - shield_hp
   local damage1 = hit/shieldMaxHP*100
   damage = maxSHP * (damage1*0.01)
   svghp = maxSHP * (HP*0.01)
   last_shield_hp = shield_hp
   --damageLine = [[<rect x="]].. svghp + 145 ..[[" y="225" width="]]..damage..[[" height="50" style="fill: #de1656; stroke: #de1656;" bx:origin="0.5 0.5"/>]]
end

lastShotTime = system.getTime()
shoteCount = shoteCount + 1
if shield.getResistancesCooldown() == 0 and shoteCount >= 5 and GHUD_shield_auto_calibration then
   local stress = shield.getStressRatioRaw()
   local resistance = shield.getResistances()
   local res = getRes(stress, resMAX)

   if GHUD_shield_calibration_max then
      if resistance[1] == res[1] and
      resistance[2] == res[2] and
      resistance[3] == res[3] and
      resistance[4] == res[4]then
         --system.print("Максимальный стресс не изменился")
      else
         if shield.setResistances(res[1],res[2],res[3],res[4]) == 1 then
            system.print("Shield power has been set to max stress")
            if res[1] > 0 then
               AM_stroke_color = '#FFB12C'
               AMstrokeWidth = 2
               unit.setTimer('AM',0.16)
            else
               AM_stroke_color = 'rgb(66, 167, 245)'
               AMstrokeWidth = 1
            end
            if res[2] > 0 then
               EM_stroke_color = '#FFB12C'
               EMstrokeWidth = 2
               unit.setTimer('EM',0.16)
            else
               EM_stroke_color = 'rgb(66, 167, 245)'
               EMstrokeWidth = 1
            end
            if res[3] > 0 then
               KI_stroke_color = '#FFB12C'
               KIstrokeWidth = 2
               unit.setTimer('KI',0.16)
            else
               KI_stroke_color = 'rgb(66, 167, 245)'
               KIstrokeWidth = 1
            end
            if res[4] > 0 then
               TH_stroke_color = '#FFB12C'
               THstrokeWidth = 2
               unit.setTimer('TH',0.16)
            else
               TH_stroke_color = 'rgb(66, 167, 245)'
               THstrokeWidth = 1
            end
         else
            system.print("ERR2")
         end
      end
   else
      local re1 = getResRatioBy2HighestDamage(stress)[1]
      local re2 = getResRatioBy2HighestDamage(stress)[2]
      local re3 = getResRatioBy2HighestDamage(stress)[3]
      local re4 = getResRatioBy2HighestDamage(stress)[4]
      if re1 == resistance[1] and
      re2 == resistance[2] and
      re3 == resistance[3] and
      re4 == resistance[4] then
         --system.print("2 максимальных стресса не изменились")
      else
         if shield.setResistances(re1,re2,re3,re4) == 1 then
            system.print("Shield power has been split 50/50%")
            if re[1] > 0 then
               AM_stroke_color = '#FFB12C'
               AMstrokeWidth = 2
               unit.setTimer('AM',0.16)
            else
               AM_stroke_color = 'rgb(66, 167, 245)'
               AMstrokeWidth = 1
            end
            if re[2] > 0 then
               EM_stroke_color = '#FFB12C'
               EMstrokeWidth = 2
               unit.setTimer('EM',0.16)
            else
               EM_stroke_color = 'rgb(66, 167, 245)'
               EMstrokeWidth = 1
            end
            if re[3] > 0 then
               KI_stroke_color = '#FFB12C'
               KIstrokeWidth = 2
               unit.setTimer('KI',0.16)
            else
               KI_stroke_color = 'rgb(66, 167, 245)'
               KIstrokeWidth = 1
            end
            if re[4] > 0 then
               TH_stroke_color = '#FFB12C'
               THstrokeWidth = 2
               unit.setTimer('TH',0.16)
            else
               TH_stroke_color = 'rgb(66, 167, 245)'
               THstrokeWidth = 1
            end
         else
            system.print("ERR3")
         end
      end
   end
end