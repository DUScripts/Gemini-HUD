radarIDs = activeRadar.getConstructIds()
idN = #radarIDs

mRadar:onUpdate()

if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
   coroutine.resume(main1)
   --coroutine.xpcall(main1) -- resume debug coroutine
end

if coroutine.status(main2) ~= "dead" and coroutine.status(main2) == "suspended" then
   coroutine.resume(main2)
   --coroutine.xpcall(main2) -- resume debug coroutine
end

if corpos == true then
   if coroutine.status(ck) ~= "dead" and coroutine.status(ck) == "suspended" then
      coroutine.resume(ck, asteroidcoord)
   end
end

local dx = system.getMouseDeltaX() * 4
local dy = system.getMouseDeltaY() * 4

damage_SVG()

local sPos = vec3(construct.getWorldPosition())
varcombat = construct.getPvPTimer()

if varcombat > 0 and varcombat < 302 then
   local stress = shield.getStressRatioRaw()
   AM_stress = stress[1]
   EM_stress = stress[2]
   KI_stress = stress[3]
   TH_stress = stress[4]
end
ccs_SVG()

local HP = shield.getShieldHitpoints()/shieldMaxHP * 100
local formatted_hp = string.format('%0.0f',math.ceil(HP))

if shield.isActive() == 0 then
   svghp = maxSHP * (HP*0.01)
   local shield_hp = shield.getShieldHitpoints()
   last_shield_hp = shield_hp
   shieldColor = "#fc033d"
   shieldStatus = "DEACTIVE"
else
   shieldColor = "#2ebac9"
   shieldStatus = "ACTIVE"
end

if (system.getArkTime() - lastShotTime) >= 40 then
   shoteCount = 0
end

local resisttime = shield.getResistancesCooldown()
if resisttime ~= 0 then
   resCLWN = math.floor(resisttime)
else
   resCLWN = ''
end

if shield.isVenting() == 1 then
   shieldStatus = 'VENTING'
end

venttime = shield.getVentingCooldown()
if venttime ~= 0 then
   resCLWN = math.floor(venttime)
end

local brakeHUD = ''
if mybr == true then
   brakeHUD = [[
   <style>
   .main1 {
      position: absolute;
      width: content;
      padding: 10px;
      top: ]]..GHUD_brake_Y..[[%;
      left: 50%;
      transform: translateX(-50%);
      text-align: center;
      background: #142027;
      color: white;
      font-family: "Lucida" Grande, sans-serif;
      font-size: 1.5em;
      border-radius: 5vh;
      border: 4px solid #FFB12C;
      </style>
      <div class="main1">BRAKE ENGAGED</div>]]
   else
      brakeHUD = ''
   end

   local warningmsg = ''
   if math.ceil(HP) <= 50 then
      warningmsg = [[<style>
      .warningmsg {
         position: absolute;
         top: ]]..GHUD_shield_warning_message_Y..[[%;
         left: 50%;
         transform: translate(-50%, -50%);
         padding: 10px;
         width: content;
         text-align: center;
         background: ]]..GHUD_background_color..[[;
         color: #fc033d;
         font-family: "Lucida" Grande, sans-serif;
         font-weight: bold;
         font-size: 1.25em;
         border-radius: 5vh;
         border: 4px solid #FFB12C;
         </style>
         <div class="warningmsg">SHIELD LOW</div>]]
      end

      if t2 == true then
         blink = blink + 0.015
         if blink >= 1 then
            t2=false
         end
      end

      if t2 == false then
         blink = blink - 0.015
         if blink < 0.4 then
            t2=true
         end
      end

      if math.ceil(HP) <= 35 then
         shieldAlarm=true
         if alarmTimer == true then
            warningmsg = [[<style>
            .warningmsg {
               position: absolute;
               top: ]]..GHUD_shield_warning_message_Y..[[%;
               left: 50%;
               transform: translate(-50%, -50%);
               padding: 10px;
               width: content;
               text-align: center;
               background: ]]..GHUD_background_color..[[;
               color: #fc033d;
               opacity: ]]..blink..[[;
               font-family: "Lucida" Grande, sans-serif;
               font-weight: bold;
               font-size: 1.25em;
               border-radius: 5vh;
               border: 4px solid #FFB12C;
               </style>
               <div class="warningmsg">SHIELD LOW</div>]]
            end
         else
            shieldAlarm = false
         end
         local thrust1 = math.floor(unit.getThrottle())
         local accel = math.floor((json.decode(unit.getWidgetData()).acceleration/9.80665)*10)/10
         local sp1 = construct.getWorldVelocity()
         local speed = math.floor(vec3(sp1):len() * 3.6)
         local maxSpeed = math.floor(construct.getMaxSpeed() * 3.6)
         --local closestPlanet = getClosestPlanet(shipPos)
         local AR_planets = ''
         local AR_asteroid = ''
         local AR_pvpzone = ''
         local AR_safezone = ''
         local Indicator = ''
         local ind = sPos + 400000 * vec3(sp1)
         local pointF = library.getPointOnScreen({ind.x,ind.y,ind.z})
         if pointF[3] > 0 and speed > 15 then --visible zone
            local x = (screenWidth*pointF[1]) - dx - GHUD_flight_indicator_size/2
            local y = (screenHeight*pointF[2]) - dy - GHUD_flight_indicator_size/2
            Indicator = [[
            <style>
            .flightIndicator {
               position: absolute;
               width: ]]..GHUD_flight_indicator_size..[[px;
               height: ]]..GHUD_flight_indicator_size..[[px;
               left: ]]..x..[[px;
               top: ]]..y..[[px;
            }
            </style>
            <div class="flightIndicator">
            <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
            <line style="fill: ]]..GHUD_flight_indicator_color..[[; stroke: ]]..GHUD_flight_indicator_color..[[; stroke-width: 20px;" x1="10" y1="100" x2="190" y2="100" transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -41.421356, 100)"></line>
            <line style="fill: ]]..GHUD_flight_indicator_color..[[; stroke: ]]..GHUD_flight_indicator_color..[[; stroke-width: 20px;" x1="10" y1="100" x2="190" y2="100" transform="matrix(0.707107, 0.707107, -0.707107, 0.707107, 100, -41.421356)"></line>
            </svg></div>]]
         end

         local safeStatus, safeVector, zoneDist, distStr = safeZone()

         if szsafe == true then
            safetext=''..safeStatus..' <green1>'..zoneDist..' '..distStr..'</green1>'
            local point1 = library.getPointOnScreen({safeVector.x,safeVector.y,safeVector.z})
            if point1[3] > 0 then --visible zone
               local x2 = (screenWidth*point1[1]) - dx - 50
               local y2 = (screenHeight*point1[2]) - dy - 50
               AR_pvpzone = [[
               <style>
               .pvpzoneAR {
                  position: absolute;
                  width: 100px;
                  height: 100px;
                  left: ]]..x2..[[px;
                  top: ]]..y2..[[px;
               }
               </style>
               <div class="pvpzoneAR"><?xml version="1.0" encoding="utf-8"?>
               <svg viewBox="0 0 250 250" xmlns="http://www.w3.org/2000/svg">
               <ellipse style="fill: rgba(0, 0, 0, 0); stroke: #fc033d; stroke-width: 8px;" cx="125" cy="125" rx="50" ry="50"/>
               <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="48.955">PvP ZONE</text>
               <text style="fill: white; font-family: verdana; font-size: 28px; font-weight: 700; text-anchor: middle;" x="125" y="209.955">]]..zoneDist..[[</text>
               <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="240.424">]]..distStr..[[</text>
               </svg></div>]]
            end
         else
            safetext=''..safeStatus..' <red1>'..zoneDist..' '..distStr..'</red1>'
            local point1 = library.getPointOnScreen({safeVector.x,safeVector.y,safeVector.z})
            if point1[3] > 0 then --visible zone
               local x2 = (screenWidth*point1[1]) - dx - 50
               local y2 = (screenHeight*point1[2]) - dy - 50
               AR_safezone = [[
               <style>
               .safezoneAR {
                  position: absolute;
                  width: 100px;
                  height: 100px;
                  left: ]]..x2..[[px;
                  top: ]]..y2..[[px;
               }
               </style>
               <div class="safezoneAR"><?xml version="1.0" encoding="utf-8"?>
               <svg viewBox="0 0 250 250" xmlns="http://www.w3.org/2000/svg">
               <ellipse style="fill: rgba(0, 0, 0, 0); stroke: #07e88e; stroke-width: 8px;" cx="125" cy="125" rx="50" ry="50"/>
               <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="48.955">SAFE ZONE</text>
               <text style="fill: white; font-family: verdana; font-size: 28px; font-weight: 700; text-anchor: middle;" x="125" y="209.955">]]..zoneDist..[[</text>
               <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="240.424">]]..distStr..[[</text>
               </svg></div>]]
            end
         end

         if asteroidcoord[1] ~= 0 then
            local point1 = library.getPointOnScreen({asteroidcoord.x,asteroidcoord.y,asteroidcoord.z})
            if point1[3] > 0 then --visible zone
               local dist = vec3(sPos - asteroidcoord):len()
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
               local x = (screenWidth*point1[1]) - dx - 50
               local y = (screenHeight*point1[2]) - dy - 50
               AR_asteroid = [[
               <style>
               .marker]]..GHUD_marker_name..[[ {
                  position: absolute;
                  width: 100px;
                  height: 100px;
                  left: ]]..x..[[px;
                  top: ]]..y..[[px;
               }
               </style>
               <div class="marker]]..GHUD_marker_name..[["><?xml version="1.0" encoding="utf-8"?>
               <svg viewBox="0 0 250 250" xmlns="http://www.w3.org/2000/svg">
               <ellipse style="fill: rgba(0, 0, 0, 0); stroke: ]]..GHUD_marker_color..[[; stroke-width: 8px;" cx="125" cy="125" rx="50" ry="50"/>
               <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="48.955">]]..GHUD_marker_name..[[</text>
               <text style="fill: white; font-family: verdana; font-size: 28px; font-weight: 700; text-anchor: middle;" x="125" y="209.955">]]..dist..[[</text>
               <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="240.424">]]..sdist..[[</text>
               </svg></div>]]
            end
         end

         if DisplayRadar==true then
            local x,y,z = table.unpack(construct.getWorldOrientationForward())
            local xoc = math.floor(math.atan(x, y)*180/math.pi+180)
            local yoc = math.floor(math.atan(y, z)*180/math.pi+180)
            local XY = [[
            <style>
            .XY {
               position: absolute;
               left: 2%;
               top: 23%;
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
                  RadarX=screenWidth*1/7
                  RadarY=screenWidth*1/7
                  RadarR=screenWidth*1/7

                  svgradar=svgradar..string.format([[<line x1="%f" y1="%f" x2="%f" y2="%f" stroke-width="2" stroke="black" />]],RadarX,RadarY-RadarR,RadarX,RadarY+RadarR)
                  svgradar=svgradar..string.format([[<line x1="%f" y1="%f" x2="%f" y2="%f" stroke-width="2" stroke="black" />]],RadarX-RadarR,RadarY,RadarX+RadarR,RadarY)
                  svgradar=svgradar..string.format([[<circle  cx="%f" cy="%f" r="%f" stroke="black" fill="transparent" stroke-width="5"/>]],
                  RadarX,RadarY,RadarR/2)
                  svgradar=svgradar..string.format([[<circle  cx="%f" cy="%f" r="%f" stroke="black" fill-opacity="0.2" fill="green" stroke-width="5"/>]],
                  RadarX,RadarY,RadarR)

                  for BodyId in pairs(atlas[0]) do
                     local planet=atlas[0][BodyId]
                     if ((planet.type[1] == 'Planet' or planet.isSanctuary == true) and planet.name[1] ~= planetzone) then
                        drawonradar(vec3(planet.center),planet.name[1])
                        local point1 = library.getPointOnScreen({planet.center[1],planet.center[2],planet.center[3]})
                        if point1[3] > 0 then --visible zone
                           local dist = vec3(sPos - vec3(planet.center)):len()
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
                           local x2 = (screenWidth*point1[1]) - dx - 50
                           local y2 = (screenHeight*point1[2]) - dy - 50
                           AR_planets = AR_planets .. [[
                           <style>
                           .pl]]..planet.name[1]..[[ {
                              position: absolute;
                              width: 100px;
                              height: 100px;
                              left: ]]..x2..[[px;
                              top: ]]..y2..[[px;
                           }
                           </style>
                           <div class="pl]]..planet.name[1]..[["><?xml version="1.0" encoding="utf-8"?>
                           <svg viewBox="0 0 250 250" xmlns="http://www.w3.org/2000/svg">
                           <ellipse style="fill: rgba(0, 0, 0, 0); stroke: #FFB12C; stroke-width: 8px;" cx="125" cy="125" rx="50" ry="50"/>
                           <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="48.955">]]..planet.name[1]..[[</text>
                           <text style="fill: white; font-family: verdana; font-size: 28px; font-weight: 700; text-anchor: middle;" x="125" y="209.955">]]..dist..[[</text>
                           <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 28px; font-style: italic; font-weight: 700; text-anchor: middle;" x="125" y="240.424">]]..sdist..[[</text>
                           </svg></div>]]
                        end
                     end
                  end
                  drawonradar(safeVector,safeStatus)
                  if szsafe == true then
                     drawonradar(safeWorldPos,'Central SZ')
                     end
                  if asteroidcoord[1] ~= 0 then
                     drawonradar(asteroidcoord,""..GHUD_marker_name.."")
                  end
                  message=message..svgradar..XY
                  message=message.."</svg>"
               else
                  message = ''
               end

               local sight = ''
               if weapon_1 ~= nil then
                  local wdata = weapon_1.getWidgetData()
                  --weapon_1.getHitProbability() for future version
                  --zone = data:match('"outOfZone":(.-),') deprecated, bad perfomance
                  probil = tonumber(wdata:match('"hitProbability":(.-),'))
               end

               local id = activeRadar.getTargetId()
               if id ~= 0 then
                  local mass = activeRadar.getConstructMass(id)
                  local tcolor = 'rgba(0, 191, 255, 0)'
                  if activeRadar.getConstructKind(id) == 5 then
                     tcolor = 'rgb(0, 191, 255)'
                  else
                     tcolor = '#c603fc'
                  end
                  if activeRadar.isConstructAbandoned(id) == 1 then
                     tcolor = '#43494a'
                  end
                  local topSpeed = '??'
                  local sdist = ""
                  local dist = math.floor(activeRadar.getConstructDistance(id))
                  distT = dist
                  local name = string.sub((""..activeRadar.getConstructName(id)..""),1,11)
                  local size = activeRadar.getConstructCoreSize(id)
                  local speed = '??'
                  local anchor = 'middle'
                  local damage = '0.0'
                  if totalDamage[id] ~= nil then --target damage calculation concept
                     damage = string.format('%0.1f',totalDamage[id].damage * 0.000001)
                  end
                  if activeRadar.isConstructIdentified(id) == 1 then
                     topSpeed = math.floor(clamp((50000/3.6-10713*(mass-10000)/(853926+(mass-10000)))*3.6,20000,50000))
                     speed = activeRadar.getConstructSpeed(id)
                     speed = math.floor(speed * 3.6)
                     speedT = speed
                     anchor = 'start'
                  end
                  local pos1 = sPos + dist * vec3(construct.getWorldOrientationForward())
                  local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
                  local sight1 = [[
                  .sight1 {
                     position: absolute;
                     opacity: 0;
                     left: 0;
                     top: 0;
                  }
                  ]]
                  if point1[3] > 0 then --visible zone
                     local x2 = (screenWidth*point1[1]) - dx - GHUD_AR_sight_size/2
                     local y2 = (screenHeight*point1[2]) - dy - GHUD_AR_sight_size/2
                     sight1 = [[
                     .sight1 {
                        position: absolute;
                        width: ]]..GHUD_AR_sight_size..[[px;
                        height: ]]..GHUD_AR_sight_size..[[px;
                        left: ]]..x2..[[px;
                        top: ]]..y2..[[px;
                     }]]
                  end
                  sight = [[
                  <style>
                  ]]..sight1..[[
                  .sight2 {
                     position: absolute;
                     width: 400px;
                     height: 400px;
                     left: 50%;
                     top: 50%;
                     transform: translate(-50%, -50%);
                  }
                  </style>
                  <div class="sight1">
                  <?xml version="1.0" encoding="utf-8"?>
                  <svg viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xmlns="http://www.w3.org/2000/svg">
                  <path style="fill: ]]..GHUD_AR_sight_color..[[;" d="M 231.231 440.732 C 230.524 444.711 227.058 447.508 223.154 447.508 C 222.675 447.508 222.191 447.465 221.705 447.379 C 141.949 433.179 78.822 370.052 64.621 290.296 C 63.825 285.83 66.802 281.564 71.268 280.769 C 75.729 279.975 80 282.95 80.794 287.416 C 93.793 360.422 151.578 418.207 224.583 431.205 C 229.051 432.001 232.026 436.266 231.231 440.732 Z M 71.268 231.231 C 71.754 231.318 72.239 231.36 72.717 231.36 C 76.621 231.36 80.087 228.563 80.794 224.584 C 93.793 151.578 151.578 93.793 224.583 80.795 C 229.049 80 232.026 75.734 231.23 71.269 C 230.435 66.802 226.166 63.829 221.704 64.622 C 141.948 78.822 78.821 141.949 64.62 221.705 C 63.825 226.171 66.802 230.436 71.268 231.231 Z M 440.732 280.769 C 436.273 279.976 432.001 282.951 431.206 287.416 C 418.207 360.422 360.422 418.208 287.417 431.206 C 282.951 432.001 279.974 436.267 280.77 440.733 C 281.477 444.712 284.942 447.509 288.847 447.509 C 289.326 447.509 289.81 447.466 290.296 447.38 C 370.052 433.18 433.179 370.052 447.38 290.296 C 448.175 285.83 445.198 281.564 440.732 280.769 Z M 387.492 112.892 L 399.109 124.508 C 423.609 151.152 440.78 184.629 447.38 221.703 C 448.176 226.169 445.199 230.435 440.733 231.23 C 436.27 232.026 432.001 229.049 431.207 224.583 C 425.206 190.887 409.664 160.43 387.49 136.126 L 375.873 124.51 C 351.57 102.336 321.113 86.793 287.417 80.793 C 282.951 79.998 279.974 75.732 280.77 71.266 C 281.565 66.8 285.839 63.825 290.296 64.619 C 327.37 71.22 360.848 88.39 387.492 112.892 Z" transform="matrix(0.707107, 0.707107, -0.707107, 0.707107, 255.999945, -106.038815)"></path>
                  </svg></div>
                  <div class="sight2">
                  <?xml version="1.0" encoding="utf-8"?>
                  <svg viewBox="0 0 600 600" xmlns="http://www.w3.org/2000/svg">
                  <defs>
                  <linearGradient id="hit_gradient" x1="50%" y1="100%" x2="50%">
                  <stop stop-color="#07e88e" stop-opacity="1" offset="]]..probil..[[" />
                  <stop stop-color="rgb(255, 255, 255)" stop-opacity="0.25" offset="0" />
                  </linearGradient>
                  </defs>
                  <path style="fill: url(#hit_gradient);" d="M 275.231 484.732 C 274.524 488.711 271.058 491.508 267.154 491.508 C 266.675 491.508 266.191 491.465 265.705 491.379 C 185.949 477.179 122.822 414.052 108.621 334.296 C 107.825 329.83 110.802 325.564 115.268 324.769 C 119.729 323.975 124 326.95 124.794 331.416 C 137.793 404.422 195.578 462.207 268.583 475.205 C 273.051 476.001 276.026 480.266 275.231 484.732 Z M 115.268 275.231 C 115.754 275.318 116.239 275.36 116.717 275.36 C 120.621 275.36 124.087 272.563 124.794 268.584 C 137.793 195.578 195.578 137.793 268.583 124.795 C 273.049 124 276.026 119.734 275.23 115.269 C 274.435 110.802 270.166 107.829 265.704 108.622 C 185.948 122.822 122.821 185.949 108.62 265.705 C 107.825 270.171 110.802 274.436 115.268 275.231 Z M 484.732 324.769 C 480.273 323.976 476.001 326.951 475.206 331.416 C 462.207 404.422 404.422 462.208 331.417 475.206 C 326.951 476.001 323.974 480.267 324.77 484.733 C 325.477 488.712 328.942 491.509 332.847 491.509 C 333.326 491.509 333.81 491.466 334.296 491.38 C 414.052 477.18 477.179 414.052 491.38 334.296 C 492.175 329.83 489.198 325.564 484.732 324.769 Z M 431.492 156.892 L 443.109 168.508 C 467.609 195.152 484.78 228.629 491.38 265.703 C 492.176 270.169 489.199 274.435 484.733 275.23 C 480.27 276.026 476.001 273.049 475.207 268.583 C 469.206 234.887 453.664 204.43 431.49 180.126 L 419.873 168.51 C 395.57 146.336 365.113 130.793 331.417 124.793 C 326.951 123.998 323.974 119.732 324.77 115.266 C 325.565 110.8 329.839 107.825 334.296 108.619 C 371.37 115.22 404.848 132.39 431.492 156.892 Z"/>
                  <text style="fill: white; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 45.470986, 456.61146)"><tspan x="254.529" y="60.003">]]..damage..[[M</tspan></text>
                  <text style="fill: ]]..tcolor..[[; font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 44.105107, 38.795308)"><tspan x="254.529" y="36.003">]]..name..[[ []]..size..[[]</tspan></text>
                  <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: start;" transform="matrix(1, 0, 0, 1, 241.470998, 244.195302)"><tspan x="254.529" y="36.003">KM/H</tspan></text>
                  <text style="fill: ]]..newcolor..[[; font-family: verdana; font-size: 26px; font-weight: 700; text-anchor: start;" transform="matrix(1, 0, 0, 1, 241.470998, 244.195302)"><tspan x="337.529" y="36.003">]]..znak..[[</tspan></text>
                  <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: end;" transform="matrix(1, 0, 0, 1, -154.09122, 244.195302)"><tspan x="254.529" y="36.003">MAX</tspan></text>
                  <text style="fill: ]]..newcolor2..[[; font-family: verdana; font-size: 26px; font-weight: 700; text-anchor: end;" transform="matrix(1, 0, 0, 1, -154.09122, 244.195302)"><tspan x="214.729" y="36.003"></tspan></text>
                  <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 43.882192, 510.395305)"><tspan x="254.529" y="36.003">DAMAGE</tspan></text>
                  <text style="fill: white; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 45.470986, 44.611463)"><tspan x="254.529" y="60.003">]]..tostring(id):sub(-3)..[[</tspan></text>
                  <text style="fill: white; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: end;" y="310.246" x="101.677">]]..topSpeed..[[</text>
                  <text style="fill: white; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: ]]..anchor..[[;" y="310.246" x="494">]]..speed..[[</text>
                  </svg></div>]]
               else
                  local pos1 = sPos + 400000 * vec3(construct.getWorldOrientationForward())
                  local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
                  --local pos1 = ConvertLocalToWorld(0,distance,0)
                  --local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
                  if point1[3] > 0 then --visible zone
                     local x2 = (screenWidth*point1[1]) - dx - GHUD_AR_sight_size/2
                     local y2 = (screenHeight*point1[2]) - dy - GHUD_AR_sight_size/2
                     sight = [[
                     <style>
                     .sight1 {
                        position: absolute;
                        width: ]]..GHUD_AR_sight_size..[[px;
                        height: ]]..GHUD_AR_sight_size..[[px;
                        left: ]]..x2..[[px;
                        top: ]]..y2..[[px;
                     }
                     </style>
                     <div class="sight1">
                     <?xml version="1.0" encoding="utf-8"?>
                     <svg viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xmlns="http://www.w3.org/2000/svg">
                     <path style="fill: ]]..GHUD_AR_sight_color..[[;" d="M 231.231 440.732 C 230.524 444.711 227.058 447.508 223.154 447.508 C 222.675 447.508 222.191 447.465 221.705 447.379 C 141.949 433.179 78.822 370.052 64.621 290.296 C 63.825 285.83 66.802 281.564 71.268 280.769 C 75.729 279.975 80 282.95 80.794 287.416 C 93.793 360.422 151.578 418.207 224.583 431.205 C 229.051 432.001 232.026 436.266 231.231 440.732 Z M 71.268 231.231 C 71.754 231.318 72.239 231.36 72.717 231.36 C 76.621 231.36 80.087 228.563 80.794 224.584 C 93.793 151.578 151.578 93.793 224.583 80.795 C 229.049 80 232.026 75.734 231.23 71.269 C 230.435 66.802 226.166 63.829 221.704 64.622 C 141.948 78.822 78.821 141.949 64.62 221.705 C 63.825 226.171 66.802 230.436 71.268 231.231 Z M 440.732 280.769 C 436.273 279.976 432.001 282.951 431.206 287.416 C 418.207 360.422 360.422 418.208 287.417 431.206 C 282.951 432.001 279.974 436.267 280.77 440.733 C 281.477 444.712 284.942 447.509 288.847 447.509 C 289.326 447.509 289.81 447.466 290.296 447.38 C 370.052 433.18 433.179 370.052 447.38 290.296 C 448.175 285.83 445.198 281.564 440.732 280.769 Z M 387.492 112.892 L 399.109 124.508 C 423.609 151.152 440.78 184.629 447.38 221.703 C 448.176 226.169 445.199 230.435 440.733 231.23 C 436.27 232.026 432.001 229.049 431.207 224.583 C 425.206 190.887 409.664 160.43 387.49 136.126 L 375.873 124.51 C 351.57 102.336 321.113 86.793 287.417 80.793 C 282.951 79.998 279.974 75.732 280.77 71.266 C 281.565 66.8 285.839 63.825 290.296 64.619 C 327.37 71.22 360.848 88.39 387.492 112.892 Z" transform="matrix(0.707107, 0.707107, -0.707107, 0.707107, 255.999945, -106.038815)"></path>
                     </svg></div>]]
                  end
               end

               local AR_allies = ''
               if GHUD_show_AR_allies_marks == true then
               for k,v in pairs(radarIDs) do --AR marks
                  if activeRadar.hasMatchingTransponder(v) == 1 then
                     local pos = activeRadar.getConstructWorldPos(v)
                     local fID = ''
                     if friendsData[v] ~= nil then
                        fID = friendsData[v].tag
                     end
                     local point = library.getPointOnScreen({pos[1],pos[2],pos[3]})
                     if point[3] > 0 then --visible zone
                        local x = (screenWidth*point[1]) - dx - GHUD_AR_allies_border_size/2
                        local y = (screenHeight*point[2]) - dy - GHUD_AR_allies_border_size/2
                        AR_allies = AR_allies .. [[
                        <style>     
                        .id]]..v..[[ {
                           position: absolute;
                           width: ]]..GHUD_AR_allies_border_size..[[px;
                           height: ]]..GHUD_AR_allies_border_size..[[px;
                           left: ]]..x..[[px;
                           top: ]]..y..[[px;
                        }
                        </style>
                        <div class="id]]..v..[["><?xml version="1.0" encoding="utf-8"?>
                        <svg viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg">
                        <rect x="235" y="235" width="30" height="30" style="fill: rgba(0,0,0,0); stroke: ]]..GHUD_AR_allies_border_color..[[; stroke-width: 2"/>
                        <text style="fill: ]]..GHUD_AR_allies_font_color..[[; font-family: Arial, sans-serif; font-size: 28px; font-weight: 700; text-anchor: middle;" transform="matrix(0.609174, 0, 0, 0.609176, 250.000005, 225)">]].. tostring(v):sub(-3) .. [[</text>
                        <text style="fill: ]]..GHUD_AR_allies_font_color..[[; font-family: Arial, sans-serif; font-size: 28px; font-weight: 700; text-anchor: middle;" transform="matrix(0.609174, 0, 0, 0.609176, 250.000005, 210)">]]..fID..[[</text>
                        </svg></div>]]
                     end
                  end
               end
               end

               --hit/miss animations, radar contacts animations
               local hitsHUD = ''
               local missesHUD = ''
               local targetsHUD = ''

               if GHUD_show_hits == true then
                  for k,v in pairs(lastHitTime) do
                     if lastHitTime[k] ~= nil then
                        lastHitTime[k].time = lastHitTime[k].time + 0.025
                        lastHitTime[k].hitOpacity = lastHitTime[k].hitOpacity - 0.015
                        local top = GHUD_hits_misses_Y - lastHitTime[k].time*3.25
                        local right = GHUD_hit_X + lastHitTime[k].time*2
                        if lastHitTime[k].hitOpacity <= 0 then lastHitTime[k].hitOpacity = 0 end
                        local hit = [[
                        <style>
                        .hit]]..k..[[ {
                           top: ]]..top..[[vh;
                           left: ]]..right..[[%;
                           position: absolute;
                           text-alight: center;
                           font-size: 40px;
                           font-family: verdana;
                           font-style: normal;
                           font-weight: bold;
                           color: #FFB12C;
                           opacity: ]]..lastHitTime[k].hitOpacity..[[;
                           transform: translate(-50%, -50%);
                        }
                        </style>
                        <div class="hit]]..k..[[">]]..lastHitTime[k].damage..[[</div>]]
                        hits[k] = {html = hit}

                        if lastHitTime[k].time >= 2 then
                           hits[k] = {html = ''}
                           if lastHitTime[k].anims == hitAnimations then
                              hits[k] = nil
                              hits = {}
                              hitAnimations = 0
                              lastHitTime = {}
                           end
                        end
                     end
                  end
               end

               if GHUD_show_misses == true then
                  for k,v in pairs(lastMissTime) do
                     if lastMissTime[k] ~= nil then
                        lastMissTime[k].time = lastMissTime[k].time + 0.025
                        lastMissTime[k].missOpacity = lastMissTime[k].missOpacity - 0.015
                        local top = GHUD_hits_misses_Y - lastMissTime[k].time*3.25
                        local left = GHUD_miss_X - lastMissTime[k].time*2
                        if lastMissTime[k].missOpacity <= 0 then lastMissTime[k].missOpacity = 0 end
                        local miss = [[
                        <style>
                        .miss]]..k..[[ {
                           top: ]]..top..[[vh;
                           left: ]]..left..[[%;
                           position: absolute;
                           text-alight: center;
                           font-size: 40px;
                           font-family: verdana;
                           font-style: normal;
                           font-weight: bold;
                           color: #fc033d;
                           opacity: ]]..lastMissTime[k].missOpacity..[[;
                           transform: translate(-50%, -50%);
                        }
                        </style>
                        <div class="miss]]..k..[[">MISS</div>]]
                        misses[k] = {html = miss}

                        if lastMissTime[k].time >= 2 then
                           misses[k] = {html = ''}
                           if lastMissTime[k].anims == missAnimations then
                              misses[k] = nil
                              misses = {}
                              missAnimations = 0
                              lastMissTime = {}
                           end
                        end
                     end
                  end
               end

               if GHUD_show_hits == true then
                  for k,v in pairs(hits) do
                     if hits[k] ~= nil then
                        hitsHUD = hitsHUD .. hits[k].html
                     end
                  end
               end

               if GHUD_show_misses == true then
                  for k,v in pairs(misses) do
                     if misses[k] ~= nil then
                        missesHUD = missesHUD .. misses[k].html
                     end
                  end
               end

               for k,v in pairs(target) do
                  if target[k] ~= nil then
                     if target[k].left > 85 and target[k].one == true then target[k].left = target[k].left - 0.3 end
                     if target[k].left <= 85 then target[k].left = 85 target[k].one = false end
                     local div = [[
                     <style>
                     .targ]]..k..[[ {
                        position: relative;
                        color: ]]..target[k].color..[[;
                        top: calc(-]]..GHUD_Y..[[vh + ]]..GHUD_radar_notifications_Y..[[vh + 68px);
                        left: ]]..target[k].left..[[%;
                        opacity: ]]..target[k].opacity..[[;
                        background-color: ]]..GHUD_radar_notifications_background_color..[[;
                        border: 2px solid ]]..GHUD_radar_notifications_border_color..[[;
                        border-radius: ]]..GHUD_border_radius..[[;
                        padding: 12px;
                        margin-top: -2px;
                        font-weight: bold;
                        font-size: 20px;
                        text-align: left;
                     }
                     </style>
                     <div class="targ]]..k..[[">[]]..target[k].size1..[[] ]]..target[k].id..[[ ]]..target[k].name1..[[</div>]]
                     targets[k] = {html = div}
                     if target[k].one == false then
                        target[k].delay = target[k].delay + 1
                        if target[k].delay >= 100 then
                           target[k].opacity = target[k].opacity - 0.01
                           if target[k].opacity <= 0 and target[k].cnt == count then
                              target[k] = nil
                              target = {}
                              targets = {}
                              count = 0
                           end
                        end
                     end
                  end
               end

               for k,v in pairs(targets) do
                  if targets[k] ~= nil then
                     targetsHUD = targetsHUD .. targets[k].html
                  end
               end

               local htmlHUD1 = [[
               <html>
               <style>
               html,body {
                  margin:0;
                  padding:0;
                  overflow: hidden;
               }
               .shield1 {
                  position: absolute;
                  width: ]]..GHUD_shield_panel_size..[[px;
                  top: ]]..GHUD_shield_panel_Y..[[%;
                  opacity: ]]..GHUD_shield_panel_opacity..[[;
                  left: 50%;
                  transform: translate(-50%, -50%);
                  filter: drop-shadow(0 0 15px blue);
               }
               .center1 {
                  position: relative;
                  margin-left: 50%;
                  margin-top: calc(]]..GHUD_Y..[[vh - 68px);
                  color: white;
               }
               .right1 {
                  color: rgb(0, 191, 255);
                  position: absolute;
                  left: ]]..GHUD_right_block_X..[[%;
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
                  right: ]]..GHUD_left_block_X..[[%;
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
                  margin-left: 40%;
                  width: 120px;
                  height: 120px;
               }
               .fuel1 {
                  position: absolute;
                  margin-top:calc(-100% + 5px);
                  margin-left: 40%;
                  width: 120px;
                  height: 120px;
               }
               red1 {
                  color: #fc033d;
               }
               green1 {
                  color: #07e88e;
               }
               white1 {
                  color: white;
               }
               mspeed {
                  color: white;
                  opacity: 0.25;
               }
               blue1 {
                  color: rgb(0, 191, 255);
               }
               it {
                  font-style: italic;
               }
               orange1 {
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
               .safez {
                  width: auto;
                  padding-top: 1px;
                  padding-bottom: 1px;
                  padding-left: 5px;
                  padding-right: 5px;
                  position:fixed;
                  top: 0;
                  right: 0;
                  text-align: right;
                  color: #FFFFFF;
                  text-align: center;
                  font-size: 1.2em;
                  font-weight: bold;
                  background: ]]..GHUD_background_color..[[;
                  border: 0.5px solid black;
               }
               .pipe {
                  width: auto;
                  padding-left: 35px;
                  padding-right: 35px;
                  padding-top: 2px;
                  padding-bottom: 2px;
                  position: fixed;
                  top: ]]..GHUD_pipe_Y..[[vh;
                  right: ]]..GHUD_pipe_X..[[vw;
                  text-align: center;
                  color: ]]..GHUD_pipe_text_color..[[;
                  font-size: 1.2em;
                  font-weight: bold;
                  background: ]]..GHUD_background_color..[[;
                  border: 0.5px solid black;
               }
               .pos1 {
                  position: absolute;
                  left: 50%;
                  top: 55%;
                  text-align:center;
                  font-size: 20px;
                  font-style: verdana;
                  font-weight: bold;
                  color: white;
                  transform: translate(-50%, -50%);
               }
               </style>
               <body>
               ]]..Indicator..[[
               ]]..AR_allies..[[
               ]]..AR_asteroid..[[
               ]]..AR_planets..[[
               ]]..AR_pvpzone..[[
               ]]..AR_safezone..[[
               ]]..message..[[
               ]]..gunnerHUD..[[
               ]]..vectorHUD..[[
               ]]..missesHUD..[[
               ]]..hitsHUD..[[
               ]]..sight..[[
               ]]..warningmsg..[[
               ]]..brakeHUD..[[]]
               local htmlHUD2 = [[
               <div class="safez">]]..safetext..[[</div>
               <div class="pipe">]]..pD()..[[</div>
               <div class="center1"></div>
               <div class="right1">THRUST<br><div class="thrust1">]]..thrust1..[[</div><orange1>%</orange1><br>SPEED<br><div class="speed1">]]..speed..[[</div><orange1>KM/H</orange1><mspeed> ]]..maxSpeed..[[</mspeed><br>ACCEL<br><div class="accel1">]]..accel..[[</div><orange1>G</orange1><br>BRAKE-DISTANCE<br><div class="brakedist">]]..brakeDist..[[</div><orange1>]]..brakeS..[[</orange1></div>
               <div class="left1">SHIELD<div class="shield2"><svg viewBox="0 0 100 100" fill="none" stroke="]]..shieldColor..[[" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" xmlns="http://www.w3.org/2000/svg">
               <path d="M 50 60 C 50 60 58 56 58 50 L 58 43 L 50 40 L 42 43 L 42 50 C 42 56 50 60 50 60 Z"/>
               <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 13px; font-weight: 700; stroke-width: 0px; text-anchor: middle;" x="50" y="53.737">]]..shieldIcon..[[</text>
               </svg></div><br><div class="shieldtext">]]..formatted_hp..[[</div><orange1>%</orange1><br>FUEL<div class="fuel1"><svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
               <g fill="none" fill-rule="evenodd" transform="matrix(1, 0, 0, 1, -18, -4.5)">
               <path d="M68 63c3.038 0 5.5-2.493 5.5-5.567 0-2.05-1.833-5.861-5.5-11.433-3.667 5.572-5.5 9.383-5.5 11.433C62.5 60.507 64.962 63 68 63z" fill="#FFB12C"/>
               </g>
               </svg></div><br><div class="fueltext">]]..fuel_lvl..[[</div><orange1>%</orange1></div>
               <div class="shield1"><?xml version="1.0" encoding="utf-8"?>
               <svg viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg" xmlns:bx="https://boxy-svg.com">
               <defs>
               <linearGradient id="AM_gradient" x1="100%" x2="0%">
               <stop stop-color="#fc033d" offset="]]..AM_svg..[[" />
               <stop stop-color="]]..GHUD_shield_background_color..[[" offset="0" />
               </linearGradient>
               <linearGradient id="EM_gradient" x1="100%" x2="0%">
               <stop stop-color="#fc033d" offset="]]..EM_svg..[[" />
               <stop stop-color="]]..GHUD_shield_background_color..[[" offset="0" />
               </linearGradient>
               <linearGradient id="TH_gradient" x1="100%" x2="0%">
               <stop stop-color="#fc033d" offset="]]..TH_svg..[[" />
               <stop stop-color="]]..GHUD_shield_background_color..[[" offset="0" />
               </linearGradient>
               <linearGradient id="KI_gradient" x1="100%" x2="0%">
               <stop stop-color="#fc033d" offset="]]..KI_svg..[[" />
               <stop stop-color="]]..GHUD_shield_background_color..[[" offset="0" />
               </linearGradient>
               </defs>
               <rect x="145" y="225" width="210" height="50" style="fill: ]]..GHUD_shield_empty_background_layer_color..[[; stroke: ]]..GHUD_shield_stroke_color..[[;" bx:origin="0.5 0.5"/>
               <rect x="145" y="225" width="]]..svghp..[[" height="50" style="fill: ]]..GHUD_shield_background_color..[[; stroke: ]]..GHUD_shield_background_color..[[;" bx:origin="0.5 0.5"/>
               ]]..damageLine..[[
               ]]..ccsLineHit..[[
               <rect x="180.2" y="220.2" width="]]..ccshp..[[" height="4.8" style="fill: white; stroke: white; stroke-width:0;"/>
               <path style="fill: rgba(0, 0, 0, 0); stroke: ]]..GHUD_shield_stroke_color..[[;" d="M 180.249 220.227 L 319.749 220.175 L 315.834 225 L 184.159 225 L 180.249 220.227 Z"/>
               <rect x="180.2" y="275" width="]]..FUEL_svg..[[" height="4.8" style="fill: #FFB12C; stroke: #FFB12C; stroke-width:0;"/>
               <path style="fill: rgba(0,0,0,0); stroke: ]]..GHUD_shield_stroke_color..[[;" d="M 180.2 275.052 L 319.7 275 L 315.785 279.825 L 184.11 279.825 L 180.2 275.052 Z" transform="matrix(-1, 0, 0, -1, 499.900004, 554.825024)"/>
               <path style="fill: url(#AM_gradient); stroke: ]]..AM_stroke_color..[[; stroke-width: ]]..AMstrokeWidth..[[;" d="M 125 215 L 185 250 L 95 250 L 85 240 L 125 215 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 465.00001)"/>
               <path style="fill: url(#TH_gradient); stroke: ]]..TH_stroke_color..[[; stroke-width: ]]..THstrokeWidth..[[;" d="M 315 225 L 325 215 L 415 215 L 355 250 L 315 225 Z"/>
               <path style="fill: url(#KI_gradient); stroke: ]]..KI_stroke_color..[[; stroke-width: ]]..KIstrokeWidth..[[;" d="M 355 250 L 415 285 L 325 285 L 315 275 L 355 250 Z"/>
               <path style="fill: url(#EM_gradient); stroke: ]]..EM_stroke_color..[[; stroke-width: ]]..EMstrokeWidth..[[;" d="M 85 260 L 95 250 L 185 250 L 125 285 L 85 260 Z" transform="matrix(-1, 0, 0, -1, 270.000006, 535.000011)"/>
               <polygon style="fill: ]]..GHUD_shield_background2_color..[[; stroke: ]]..GHUD_shield_stroke_color..[[; stroke-linejoin: round; stroke-linecap: round;" points="239 225 244 231 256 231 261 225"></polygon>
               <polygon style="fill: ]]..GHUD_shield_background2_color..[[; stroke: ]]..GHUD_shield_stroke_color..[[; stroke-linejoin: round; stroke-linecap: round;" points="235 269 240 275 260 275 265 269" transform="matrix(-1, 0, 0, -1, 500, 544)"></polygon>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 4.5px; font-weight: 700; text-anchor: middle;" transform="matrix(1, 0, 0, 1, -1.542758, -0.533447)"><tspan x="251.796" y="230.112">]]..resCLWN..[[</tspan></text>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 4px; font-weight: 700; text-anchor: middle;" x="250.048" y="273.416">]]..shieldStatus..[[</text>
               <text style="fill: ]]..GHUD_shield_stroke_color..[[; font-family: Arial, sans-serif; font-weight: bold; font-size: 3.2px; text-anchor: middle;" x="250" y="223.591">CCS</text>
               <polygon style="fill: ]]..GHUD_shield_background2_color..[[; stroke: ]]..GHUD_shield_stroke_color..[[; stroke-linejoin: round; stroke-linecap: round;" points="235 279.8 240 285.8 260 285.8 265 279.8"></polygon>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 4px; font-weight: 700; text-anchor: middle;" x="250.28" y="284.311">]]..avWarp..[[/]]..totalWarp..[[</text>
               <path style="fill: ]]..GHUD_shield_background2_color..[[; stroke: ]]..GHUD_shield_stroke_color..[[; stroke-linecap: round; stroke-linejoin: round;" d="M 220 279.8 L 225 285.8 L 240 285.8 L 235 279.8 L 220 279.8 Z" transform="matrix(-1, 0, 0, -1, 460, 565.599976)"></path>
               <path style="fill: ]]..GHUD_shield_background2_color..[[; stroke: ]]..GHUD_shield_stroke_color..[[; stroke-linecap: round; stroke-linejoin: round;" d="M 265 279.8 L 260 285.8 L 275 285.8 L 280 279.8 L 265 279.8 Z" transform="matrix(-1, 0, 0, -1, 540, 565.599976)"></path>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 3.5px; font-weight: 700; text-anchor: middle;" x="230.218" y="284.182">WARP</text>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 3.5px; font-weight: 700; text-anchor: middle;" x="269.736" y="284.129">CELLS</text>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: ]]..GHUD_shield_text_stroke_color..[[; stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -0.542236, -41.161256)"><tspan x="351.543" y="319.558">KI</tspan></text>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: ]]..GHUD_shield_text_stroke_color..[[; stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -4.542999, -86.161257)"><tspan x="351.543" y="319.558">TH</tspan></text>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: ]]..GHUD_shield_text_stroke_color..[[; stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -219.543004, -41.161256)"><tspan x="351.543" y="319.558">EM</tspan></text>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 16px; font-weight: 700; paint-order: stroke; stroke: ]]..GHUD_shield_text_stroke_color..[[; stroke-width: 1.25px;" transform="matrix(1, 0, 0, 1, -219.543004, -86.161257)"><tspan x="351.543" y="319.558">AM</tspan></text>
               <text style="fill: ]]..GHUD_shield_text_color..[[; font-family: Arial, sans-serif; font-size: 20px; font-weight: 700; paint-order: stroke; stroke: ]]..GHUD_shield_text_stroke_color..[[; stroke-width: 1.25px; text-anchor: middle;" x="252" y="257.079">]]..formatted_hp..[[%</text>
               ]]..AM_res..[[
               ]]..EM_res..[[
               ]]..KI_res..[[
               ]]..TH_res..[[
               </svg></div>
               <div class="pos1">]]..pp1..[[</div>
               </body>
               </html>]]

               if map == 0 and helper == false and helper1 == false then system.setScreen(htmlHUD1 .. htmlHUD2 .. targetsHUD) end