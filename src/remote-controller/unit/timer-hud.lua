damageLine = ''
if damage > 0 then
    local curTime = system.getArkTime()
    local time = curTime - lastDamageTime
    damage = damage - 1
    damageLine = [[<rect x="]].. svghp + 145 ..[[" y="225" width="]]..damage..[[" height="50" style="fill: rgb(212, 42, 96); stroke: rgb(212, 42, 96);" bx:origin="0.5 0.5"/>]]
end
    if damage <= 0 then
    damage = 0
    damageLine = ''
end

local stress = shield.getStressRatioRaw()
AM_stress = stress[1]
EM_stress = stress[2]
KI_stress = stress[3]
TH_stress = stress[4]

hudHTML = [[
<html>
<style>
.shield {
position: absolute;
width: 1200px;
top: 50%;
left: 50%;
transform: translate(-50%, -50%);
filter: drop-shadow(0 0 35px blue);
}
</style>
<body>
<div class="shield"><?xml version="1.0" encoding="utf-8"?>
<svg viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://boxy-svg.com">
<defs>
<linearGradient id="AM_gradient" x1="100%"; x2="0%";>
        <stop stop-color="red" offset="]]..AM_stress..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="EM_gradient" x1="100%"; x2="0%";>
        <stop stop-color="red" offset="]]..EM_stress..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="TH_gradient" x1="100%"; x2="0%";>
        <stop stop-color="red" offset="]]..TH_stress..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="KI_gradient" x1="100%"; x2="0%";>
        <stop stop-color="red" offset="]]..KI_stress..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
</defs>
  <rect x="145" y="225" width="210" height="50" style="fill: #3b3c3d; stroke: rgb(15, 100, 212);" bx:origin="0.5 0.5"/>
  <rect x="145" y="225" width="]]..svghp..[[" height="50" style="fill: rgb(15, 100, 212); stroke: rgb(15, 100, 212);" bx:origin="0.5 0.5"/>
  ]]..damageLine..[[
  <rect x="180.2" y="220.2" width="35" height="4.8" style="fill: white; stroke: white; stroke-width:0;"/>
  <path style="fill: rgba(0, 0, 0, 0); stroke: rgb(66, 167, 245);" d="M 180.249 220.227 L 319.749 220.175 L 315.834 225 L 184.159 225 L 180.249 220.227 Z"/>
  <rect x="180.2" y="275" width="90" height="4.8" style="fill: rgb(255, 177, 44); stroke: rgb(255, 177, 44); stroke-width:0;"/>
  <path style="fill: rgba(0,0,0,0); stroke: rgb(66, 167, 245);" d="M 180.2 275.052 L 319.7 275 L 315.785 279.825 L 184.11 279.825 L 180.2 275.052 Z" transform="matrix(-1, 0, 0, -1, 499.900004, 554.825024)"/>
  <path style="fill: url(#AM_gradient); stroke: rgb(66, 167, 245);" d="M 125 215 L 185 250 L 95 250 L 85 240 L 125 215 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 465.00001)"/>
  <path style="fill: url(#TH_gradient); stroke: rgb(66, 167, 245);" d="M 315 225 L 325 215 L 415 215 L 355 250 L 315 225 Z"/>
  <path style="fill: url(#KI_gradient); stroke: rgb(66, 167, 245);" d="M 355 250 L 415 285 L 325 285 L 315 275 L 355 250 Z"/>
  <path style="fill: url(#EM_gradient); stroke: rgb(66, 167, 245);" d="M 85 260 L 95 250 L 185 250 L 125 285 L 85 260 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 535.000011)"/>
  <text style="white-space: pre; fill: white; font-family: Arial, sans-serif; font-size: 28px; text-shadow: 3px 0 2px black, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;" transform="matrix(0.530888, 0, 0, 0.53089, 350.000068, 278.000006)">KI</text>
  <text style="white-space: pre; fill: white; font-family: Arial, sans-serif; font-size: 28px; text-shadow: 4px 0 2px black, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;" transform="matrix(0.678357, 0, 0, 0.67836, 232.000051, 257.914373)">]]..shieldHP..[[%</text>
  <text style="white-space: pre; fill: rgb(66, 167, 245); font-family: Arial, sans-serif; font-weight: bold; font-size: 3.2px;" x="252" y="223.591">CCS</text>
</svg></div>
</body>
</html>]]
