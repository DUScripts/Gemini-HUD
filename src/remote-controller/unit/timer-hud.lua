damage_ccs_SVG()

local stress = shield.getStressRatioRaw()
AM_stress = stress[1]
EM_stress = stress[2]
KI_stress = stress[3]
TH_stress = stress[4]

checkSvgStress()

local HPS = math.floor(shield.getShieldHitpoints()/shieldMaxHP*100)
formatted_hp = string.format('%0.0f',math.ceil(HPS))

hudHTML = [[
<html>
<style>
.shield {
position: absolute;
width: 1200px;
top: 80%;
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
        <stop stop-color="#de1656" offset="]]..AM_svg..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="EM_gradient" x1="100%"; x2="0%";>
        <stop stop-color="#de1656" offset="]]..EM_svg..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="TH_gradient" x1="100%"; x2="0%";>
        <stop stop-color="#de1656" offset="]]..TH_svg..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="KI_gradient" x1="100%"; x2="0%";>
        <stop stop-color="#de1656" offset="]]..KI_svg..[[" />
        <stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
</defs>
  <rect x="145" y="225" width="210" height="50" style="fill: #3b3c3d; stroke: rgb(15, 100, 212);" bx:origin="0.5 0.5"/>
  <rect x="145" y="225" width="]]..svghp..[[" height="50" style="fill: rgb(15, 100, 212); stroke: rgb(15, 100, 212);" bx:origin="0.5 0.5"/>
  ]]..damageLine..[[
  ]]..ccsLineHit..[[      
  <rect x="180.2" y="220.2" width="]]..ccshp..[[" height="4.8" style="fill: white; stroke: white; stroke-width:0;"/>
  <path style="fill: rgba(0, 0, 0, 0); stroke: rgb(66, 167, 245);" d="M 180.249 220.227 L 319.749 220.175 L 315.834 225 L 184.159 225 L 180.249 220.227 Z"/>
  <rect x="180.2" y="275" width="]]..FUEL_svg..[[" height="4.8" style="fill: rgb(255, 177, 44); stroke: rgb(255, 177, 44); stroke-width:0;"/>
  <path style="fill: rgba(0,0,0,0); stroke: rgb(66, 167, 245);" d="M 180.2 275.052 L 319.7 275 L 315.785 279.825 L 184.11 279.825 L 180.2 275.052 Z" transform="matrix(-1, 0, 0, -1, 499.900004, 554.825024)"/>
  <path style="fill: url(#AM_gradient); stroke: ]]..AM_stroke_color..[[; stroke-width: ]]..AMstrokeWidth..[[;" d="M 125 215 L 185 250 L 95 250 L 85 240 L 125 215 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 465.00001)"/>
  <path style="fill: url(#TH_gradient); stroke: ]]..TH_stroke_color..[[; stroke-width: ]]..THstrokeWidth..[[;" d="M 315 225 L 325 215 L 415 215 L 355 250 L 315 225 Z"/>
  <path style="fill: url(#KI_gradient); stroke: ]]..KI_stroke_color..[[; stroke-width: ]]..KIstrokeWidth..[[;" d="M 355 250 L 415 285 L 325 285 L 315 275 L 355 250 Z"/>
  <path style="fill: url(#EM_gradient); stroke: ]]..EM_stroke_color..[[; stroke-width: ]]..EMstrokeWidth..[[;" d="M 85 260 L 95 250 L 185 250 L 125 285 L 85 260 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 535.000011)"/>
  <text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -0.542236, -41.161256)"><tspan x="351.543" y="319.558">KI</tspan></text>
  <text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -4.542999, -86.161257)"><tspan x="351.543" y="319.558">TH</tspan></text>
  <text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -219.543004, -41.161256)"><tspan x="351.543" y="319.558">EM</tspan></text>
  <text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -219.543004, -86.161257)"><tspan x="351.543" y="319.558">AM</tspan></text>
  <text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 20px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px; alignment-baseline: middle; text-anchor: middle;" transform="matrix(1, 0, 0, 1, -93.528017, -62.474306)"><tspan x="346" y="319.558">]]..formatted_hp..[[%</tspan></text>
</svg></div>
</body>
</html>]]
system.setScreen(hudHTML)
