if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
   coroutine.resume(main1, shipPos)
   --coroutine.xpcall(main1) -- resume debug coroutine
end

damage_ccs_SVG()

local stress = shield.getStressRatioRaw()
AM_stress = stress[1]
EM_stress = stress[2]
KI_stress = stress[3]
TH_stress = stress[4]

checkSvgStress()
local HP = shield.getShieldHitpoints()/shieldMaxHP * 100
local HPS = math.floor(HP)
local formatted_hp = string.format('%0.0f',math.ceil(HP))

if shield.getState() == 0 then
   svghp = maxSHP * (HP*0.01)
end

if (system.getTime() - lastShotTime) >= 40 then
   shoteCount = 0
   end

   AR_planets = ''
   AR_asteroid = ''
   if DisplayRadar==true then
      local x,y,z = table.unpack(construct.getWorldOrientationForward())
      local xoc = math.floor(math.atan(x, y)*180/math.pi+180)
      local yoc = math.floor(math.atan(y, z)*180/math.pi+180)
      local XY = [[
      <style>
      .XY {
         position: absolute;
         left: 2%;
         top: 26%;
         color: #FFB12C;
         font-size:18px;
         font-family: verdana;
         font-weight: bold;
         text-align: left;
      }</style>
      <div class="XY">X: ]]..xoc..[[<br>Y: ]]..yoc..[[</div>]]
      message=[[
      <style>
      .svg {
         position:absolute;
         left: 0;
         top: 6vh;
         height: 100vh;
         width: 100vw;
         .wptxt {
            fill: white;
            font-size: ]].. screenHeight/80 ..[[;
            font-family: sans-serif;
            text-anchor: end;
            .shiptxt {
               fill: white;
               font-size: ]].. screenHeight/80 ..[[;
               font-family: sans-serif;
               text-anchor: start;
            }
            </style>]]
            message=message..[[<svg class="svg">]]
            svgradar=""
            RadarX=screenWidth*1/6
            RadarY=screenWidth*1/6
            RadarR=screenWidth*1/6
   
            svgradar=svgradar..string.format([[<line x1="%f" y1="%f" x2="%f" y2="%f" stroke-width="2" stroke="black" />]],RadarX,RadarY-RadarR,RadarX,RadarY+RadarR)
            svgradar=svgradar..string.format([[<line x1="%f" y1="%f" x2="%f" y2="%f" stroke-width="2" stroke="black" />]],RadarX-RadarR,RadarY,RadarX+RadarR,RadarY)
            svgradar=svgradar..string.format([[<circle  cx="%f" cy="%f" r="%f" stroke="black" fill="transparent" stroke-width="5"/>]],
            RadarX,RadarY,RadarR/2)
            svgradar=svgradar..string.format([[<circle  cx="%f" cy="%f" r="%f" stroke="black" fill-opacity="0.2" fill="green" stroke-width="5"/>]],
            RadarX,RadarY,RadarR)
   
            for BodyId in pairs(atlas[0]) do
               local planet=atlas[0][BodyId]
               if (planet.type[1] == 'Planet' or planet.isSanctuary == true) then
                  drawonradar(vec3(planet.center),planet.name[1])
                  local point1 = library.getPointOnScreen({planet.center.x,planet.center.y,planet.center.z})
                  if point1[3] > 0 then --visible zone
                     local dist = vec3(shipPos - vec3(planet.center)):len()
                     local sdist = ''
                     if dist >= 100000 then
                        dist = string.format('%0.2f', dist/200000)
                        sdist = 'SU'
                     elseif dist >= 1000 and dist < 100000 then
                        dist = string.format('%0.1f', dist/1000)
                        sdist = 'KM'
                     else
                        dist = string.format('%0.0f', dist)
                        sdist = 'M'
                     end
                     local x2 = screenWidth*point1[1] - 50
                     local y2 = screenHeight*point1[2] - 50
                     AR_planets = AR_planets .. [[
                     <style>
                     .]]..planet.name[1]..[[ {
                        position: absolute;
                        width: 100px;
                        height: 100px;
                        left: ]]..x2..[[px;
                        top: ]]..y2..[[px;
                     }
                     </style>
                     <div class="]]..planet.name[1]..[["><?xml version="1.0" encoding="utf-8"?>
                     <svg viewBox="0 0 250 250" xmlns="http://www.w3.org/2000/svg">
                     <ellipse style="fill: rgba(0, 0, 0, 0); stroke: #FFB12C; stroke-width: 8px;" cx="125" cy="125" rx="50" ry="50"/>
                     <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; white-space: pre; text-anchor: middle;" x="125" y="48.955">]]..planet.name[1]..[[</text>
                     <text style="fill: white; font-family: verdana; font-size: 28px; font-weight: 700; white-space: pre; text-anchor: middle;" x="125" y="209.955">]]..dist..[[</text>
                     <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle; white-space: pre;" x="125" y="240.424">]]..sdist..[[</text>
                     </svg></div>]]
                  end
               end --end draw radar
            end
            drawonradar(safeWorldPos,"CENTRAL SZ")
            if asteroidPOS ~= "" then
               drawonradar(asteroidcoord,""..markerName.."")
               local point1 = library.getPointOnScreen({asteroidcoord.x,asteroidcoord.y,asteroidcoord.z})
               if point1[3] > 0 then --visible zone
                  local dist = vec3(shipPos - asteroidcoord):len()
                  local sdist = ''
                  if dist >= 100000 then
                     dist = string.format('%0.2f', dist/200000)
                     sdist = 'SU'
                  elseif dist >= 1000 and dist < 100000 then
                     dist = string.format('%0.1f', dist/1000)
                     sdist = 'KM'
                  else
                     dist = string.format('%0.0f', dist)
                     sdist = 'M'
                  end
                  local x2 = screenWidth*point1[1] - 50
                  local y2 = screenHeight*point1[2] - 50
                  AR_asteroid = [[
                  <style>
                  .]].markerName..[[ {
                     position: absolute;
                     width: 100px;
                     height: 100px;
                     left: ]]..x2..[[px;
                     top: ]]..y2..[[px;
                  }
                  </style>
                  <div class="]]..markerName..[["><?xml version="1.0" encoding="utf-8"?>
                  <svg viewBox="0 0 250 250" xmlns="http://www.w3.org/2000/svg">
                  <ellipse style="fill: rgba(0, 0, 0, 0); stroke: red; stroke-width: 8px;" cx="125" cy="125" rx="50" ry="50"/>
                  <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; white-space: pre; text-anchor: middle;" x="125" y="48.955">]]..markerName..[[</text>
                  <text style="fill: white; font-family: verdana; font-size: 28px; font-weight: 700; white-space: pre; text-anchor: middle;" x="125" y="209.955">]]..dist..[[</text>
                  <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle; white-space: pre;" x="125" y="240.424">]]..sdist..[[</text>
                  </svg></div>]]
               end
            end --end asteroid
            message=message..svgradar..XY
            message=message.."</svg>"
         else
            message = ''
         end

local htmlHUD = [[
<html>
<style>
html,body {
   margin:0;
   padding:0;
   overflow: hidden;
}
.shield1 {
   position: absolute;
   width: 900px;
   top: 90%;
   left: 50%;
   opacity: 0.75;
   transform: translate(-50%, -50%);
   filter: drop-shadow(0 0 25px blue);
}
.center1 {
   position: relative;
   margin-left: 50%;
   margin-top: calc(50vh - 68px);
   color: white;
}
.right1 {
   color: rgb(0, 191, 255);
   position: absolute;
   left: 65%;
   text-align:left;
   font-size:18px;
   font-family: verdana;
   font-weight: bold;
   text-shadow: 1px 0 1px #000,
   0 1px 1px #000,
   -1px 0 1px #000,
   0 -1px 1px #000;
}
.thrust1 {
   color: white;
   position: absolute;
   width: 100%;
   display: flex;
   font-size:20px;
   justify-content: flex-end;
   left: -101%;
   margin-top: -1px;
}
.speed1 {
   color: white;
   position: absolute;
   width: 100%;
   display: flex;
   font-size:20px;
   justify-content: flex-end;
   left: -101%;
   margin-top: -1px;
}
.accel1 {
   color: white;
   position: absolute;
   width: 100%;
   display: flex;
   font-size:20px;
   justify-content: flex-end;
   left: -101%;
   margin-top: -1.5px;
}
.brakedist {
   color: white;
   position: absolute;
   width: 100%;
   display: flex;
   font-size:20px;
   justify-content: flex-end;
   left: -101%;
   margin-top: -1.5px;
}
.left1 {
   color: rgb(0, 191, 255);
   position: absolute;
   right: 65%;
   text-align: right;
   font-size:18px;
   font-family: verdana;
   font-weight: bold;
   text-shadow: 1px 0 1px #000,
   0 1px 1px #000,
   -1px 0 1px #000,
   0 -1px 1px #000;
}
.shieldtext {
   color: white;
   position: absolute;
   width: 100%;
   display: flex;
   justify-content: flex-end;
   font-size:20px;
   margin-left: -23px;
   margin-top: -1px;
}
.fueltext {
   color: white;
   position: absolute;
   width: 100%;
   display: flex;
   justify-content: flex-end;
   font-size:20px;
   margin-left: -23px;
   margin-top: -1px;
}
.shield2 {
   position: absolute;
   margin-top: calc(-100% + 5px);
   margin-left: 38%;
   width: 120px;
   height: 100px;
}
.fuel1 {
   position: absolute;
   margin-top:calc(-100% + 5px);
   margin-left: 38%;
   width: 120px;
   height: 120px;
}
red {
   color: #fc033d;
}
green {
   color: #07e88e;
}
white {
   color: white;
}
blue {
   color: rgb(0, 191, 255);
}
it {
   font-style: italic;
}
orange {
   color: #FFB12C;
}
.sight1 {
   position: absolute;
   width: 200px;
   height: 200px;
   left: 50%;
   top: 50%;
   transform: translate(-50%, -50%);
}
.sight2 {
   position: absolute;
   width: 400px;
   height: 400px;
   left: 50%;
   top: 50%;
   transform: translate(-50%, -50%);
}
.dotsight {
   position: absolute;
   width: 30px;
   height: 30px;
   left: 50%;
   top: 50%;
   transform: translate(-50%, -50%);
}
</style>
<body>
<div class="center1"></div>
<div class="right1"><it>THRUST</it><br><div class="thrust1">]]..thrust..[[</div><orange>%</orange><br><it>SPEED</it><br><div class="speed1">]]..speed..[[</div><orange>KM/H</orange><br><it>ACCEL</it><br><div class="accel1">]]..accel..[[</div><orange>G</orange><br><it>BRAKE-DISTANCE</it><br><div class="brakedist">]]..brakeDist..[[</div><orange>]]..brakeS..[[</orange></div>
<div class="left1"><it>SHIELD</it><div class="shield2"><svg viewBox="0 0 100 100" fill="none" stroke="#2ebac9" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" xmlns="http://www.w3.org/2000/svg">
<path d="M 50 60 C 50 60 58 56 58 50 L 58 43 L 50 40 L 42 43 L 42 50 C 42 56 50 60 50 60 Z"/>
</svg></div><br><div class="shieldtext">]]..formatted_hp..[[</div><orange>%</orange><br><it>FUEL</it><div class="fuel1"><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<g fill="none" fill-rule="evenodd" transform="matrix(1, 0, 0, 1, -18, -4.5)">
<path d="M68 63c3.038 0 5.5-2.493 5.5-5.567 0-2.05-1.833-5.861-5.5-11.433-3.667 5.572-5.5 9.383-5.5 11.433C62.5 60.507 64.962 63 68 63z" fill="#FFB12C"/>
</g>
</svg></div><br><div class="fueltext">]]..fuelLvl..[[</div><orange>%</orange></div>
<div class="shield1"><?xml version="1.0" encoding="utf-8"?>
<svg viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://boxy-svg.com">
<defs>
<linearGradient id="AM_gradient" x1="100%"; x2="0%";>
<stop stop-color="#fc033d" offset="]]..AM_svg..[[" />
<stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="EM_gradient" x1="100%"; x2="0%";>
<stop stop-color="#fc033d" offset="]]..EM_svg..[[" />
<stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="TH_gradient" x1="100%"; x2="0%";>
<stop stop-color="#fc033d" offset="]]..TH_svg..[[" />
<stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
<linearGradient id="KI_gradient" x1="100%"; x2="0%";>
<stop stop-color="#fc033d" offset="]]..KI_svg..[[" />
<stop stop-color="rgb(15, 100, 212)" offset="0" />
</linearGradient>
</defs>
<rect x="145" y="225" width="210" height="50" style="fill: #3b3c3d; stroke: rgb(15, 100, 212);" bx:origin="0.5 0.5"/>
<rect x="145" y="225" width="]]..svghp..[[" height="50" style="fill: rgb(15, 100, 212); stroke: rgb(15, 100, 212);" bx:origin="0.5 0.5"/>
]]..damageLine..[[
]]..ccsLineHit..[[
<rect x="180.2" y="220.2" width="]]..ccshp..[[" height="4.8" style="fill: white; stroke: white; stroke-width:0;"/>
<path style="fill: rgba(0, 0, 0, 0); stroke: rgb(66, 167, 245);" d="M 180.249 220.227 L 319.749 220.175 L 315.834 225 L 184.159 225 L 180.249 220.227 Z"/>
<rect x="180.2" y="275" width="]]..FUEL_svg..[[" height="4.8" style="fill: #FFB12C; stroke: #FFB12C; stroke-width:0;"/>
<path style="fill: rgba(0,0,0,0); stroke: rgb(66, 167, 245);" d="M 180.2 275.052 L 319.7 275 L 315.785 279.825 L 184.11 279.825 L 180.2 275.052 Z" transform="matrix(-1, 0, 0, -1, 499.900004, 554.825024)"/>
<path style="fill: url(#AM_gradient); stroke: ]]..AM_stroke_color..[[; stroke-width: ]]..AMstrokeWidth..[[;" d="M 125 215 L 185 250 L 95 250 L 85 240 L 125 215 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 465.00001)"/>
<path style="fill: url(#TH_gradient); stroke: ]]..TH_stroke_color..[[; stroke-width: ]]..THstrokeWidth..[[;" d="M 315 225 L 325 215 L 415 215 L 355 250 L 315 225 Z"/>
<path style="fill: url(#KI_gradient); stroke: ]]..KI_stroke_color..[[; stroke-width: ]]..KIstrokeWidth..[[;" d="M 355 250 L 415 285 L 325 285 L 315 275 L 355 250 Z"/>
<path style="fill: url(#EM_gradient); stroke: ]]..EM_stroke_color..[[; stroke-width: ]]..EMstrokeWidth..[[;" d="M 85 260 L 95 250 L 185 250 L 125 285 L 85 260 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 535.000011)"/>
<text style="fill: rgb(66, 167, 245); font-family: Arial, sans-serif; font-weight: bold; font-size: 3.2px;" x="252" y="223.591">CCS</text>
<text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -0.542236, -41.161256)"><tspan x="351.543" y="319.558">KI</tspan></text>
<text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -4.542999, -86.161257)"><tspan x="351.543" y="319.558">TH</tspan></text>
<text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -219.543004, -41.161256)"><tspan x="351.543" y="319.558">EM</tspan></text>
<text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -219.543004, -86.161257)"><tspan x="351.543" y="319.558">AM</tspan></text>
<text style="fill: rgb(255, 252, 252); font-family: Arial, sans-serif; font-size: 20px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 1.25px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, -93.528017, -62.474306)"><tspan x="352" y="320">]]..formatted_hp..[[%</tspan></text>
</svg></div>
<div class="dotsight"><?xml version="1.0" encoding="utf-8"?>
  <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
    <ellipse style="fill:rgba(255, 255, 255, 0.5); stroke:rgba(255, 255, 255, 0.5);" cx="50" cy="50" rx="6" ry="6"/>
  </svg></div>
</body>
</html>]]

system.setScreen(htmlHUD)