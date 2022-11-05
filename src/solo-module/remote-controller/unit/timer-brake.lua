fuel_lvl = json.decode(spacefueltank_1.getWidgetData()).percentage
local c = 8333.333
local m0 = construct.getMass()
local v0 = vec3(construct.getWorldVelocity())
local controllerData = json.decode(unit.getWidgetData())
local maxBrakeThrust = controllerData.maxBrake
local dis = 0.0
local v = v0:len()
while v>1.0 do
   local m = m0 / (math.sqrt(1 - (v * v) / (c * c)))
   local a = maxBrakeThrust / m
   if v > a then
      v = v - a --*1 sec
      dis = dis + v + a / 2.0
   elseif a ~= 0 then
      local t = v/a
      dis = dis + v * t + a*t*t/2
      v = v - a
   end
end
if dis > 100000 then
   brakeDist = string.format(math.floor((dis/200000) * 10)/10)
   brakeS = "SU"
elseif dis > 1000 then
   brakeDist = string.format(math.floor((dis/1000)*10)/10)
   brakeS = "KM"
else
   brakeDist = string.format(math.floor(dis))
   brakeS = "M"
end