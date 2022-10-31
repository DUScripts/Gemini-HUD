radarIDs = radar.getConstructIds()
idN = #radarIDs

if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
   coroutine.resume(main1)
   --coroutine.xpcall(main1) -- resume debug coroutine
end

--local shipPos = vec3(construct.getWorldPosition())
local id = radar.getTargetId()
if id ~= 0 then
   local sdist = ""
   local dist = radar.getConstructDistance(id)
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
   local name = radar.getConstructName(id)
   local size = radar.getConstructCoreSize(id)
   local speed = 'LOCK REQUIRED'
   newcolor = 'white'
   lastspeed = 0
   local damage = 0
   if totalDamage[id] ~= nil then --target damage calculation concept
      damage = string.format('%0.1f',totalDamage[id].damage * 0.000001)
   end
   if radar.isConstructIdentified(id) == 1 then
      speed = radar.getConstructSpeed(id)
      if speed > lastspeed then newcolor = '#00d0ff' znak = '↑' end
      if speed < lastspeed then newcolor = '#fc033d' znak = '↓' end
      if speed == lastspeed then newcolor = 'white' znak = '' end
      lastspeed = speed
      speed = math.floor(speed * 3.6)
   end
   local pos1 = shipPos + distance * vec3(construct.getWorldOrientationForward())
   local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
   if point1[3] > 0 then --visible zone
      local x2 = screenWidth*point1[1] - 100
      local y2 = screenHeight*point1[2] - 100
      sight = [[
      <style>
      .sight1 {
         position: absolute;
         width: 200px;
         height: 200px;
         left: ]]..x2..[[px;
         top: ]]..y2..[[px;
      }
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
      <path style="fill: ]]..GHUD_AR_sight_color..[[;" d="M 231.231 440.732 C 230.524 444.711 227.058 447.508 223.154 447.508 C 222.675 447.508 222.191 447.465 221.705 447.379 C 141.949 433.179 78.822 370.052 64.621 290.296 C 63.825 285.83 66.802 281.564 71.268 280.769 C 75.729 279.975 80 282.95 80.794 287.416 C 93.793 360.422 151.578 418.207 224.583 431.205 C 229.051 432.001 232.026 436.266 231.231 440.732 Z M 71.268 231.231 C 71.754 231.318 72.239 231.36 72.717 231.36 C 76.621 231.36 80.087 228.563 80.794 224.584 C 93.793 151.578 151.578 93.793 224.583 80.795 C 229.049 80 232.026 75.734 231.23 71.269 C 230.435 66.802 226.166 63.829 221.704 64.622 C 141.948 78.822 78.821 141.949 64.62 221.705 C 63.825 226.171 66.802 230.436 71.268 231.231 Z M 440.732 280.769 C 436.273 279.976 432.001 282.951 431.206 287.416 C 418.207 360.422 360.422 418.208 287.417 431.206 C 282.951 432.001 279.974 436.267 280.77 440.733 C 281.477 444.712 284.942 447.509 288.847 447.509 C 289.326 447.509 289.81 447.466 290.296 447.38 C 370.052 433.18 433.179 370.052 447.38 290.296 C 448.175 285.83 445.198 281.564 440.732 280.769 Z M 387.492 112.892 L 399.109 124.508 C 423.609 151.152 440.78 184.629 447.38 221.703 C 448.176 226.169 445.199 230.435 440.733 231.23 C 436.27 232.026 432.001 229.049 431.207 224.583 C 425.206 190.887 409.664 160.43 387.49 136.126 L 375.873 124.51 C 351.57 102.336 321.113 86.793 287.417 80.793 C 282.951 79.998 279.974 75.732 280.77 71.266 C 281.565 66.8 285.839 63.825 290.296 64.619 C 327.37 71.22 360.848 88.39 387.492 112.892 Z"/>
      </svg></div>
      <div class="sight2">
      <?xml version="1.0" encoding="utf-8"?>
      <svg viewBox="0 0 600 600" xmlns="http://www.w3.org/2000/svg">
      <path style="fill: rgba(255, 255, 255, 0.25);" d="M 275.231 484.732 C 274.524 488.711 271.058 491.508 267.154 491.508 C 266.675 491.508 266.191 491.465 265.705 491.379 C 185.949 477.179 122.822 414.052 108.621 334.296 C 107.825 329.83 110.802 325.564 115.268 324.769 C 119.729 323.975 124 326.95 124.794 331.416 C 137.793 404.422 195.578 462.207 268.583 475.205 C 273.051 476.001 276.026 480.266 275.231 484.732 Z M 115.268 275.231 C 115.754 275.318 116.239 275.36 116.717 275.36 C 120.621 275.36 124.087 272.563 124.794 268.584 C 137.793 195.578 195.578 137.793 268.583 124.795 C 273.049 124 276.026 119.734 275.23 115.269 C 274.435 110.802 270.166 107.829 265.704 108.622 C 185.948 122.822 122.821 185.949 108.62 265.705 C 107.825 270.171 110.802 274.436 115.268 275.231 Z M 484.732 324.769 C 480.273 323.976 476.001 326.951 475.206 331.416 C 462.207 404.422 404.422 462.208 331.417 475.206 C 326.951 476.001 323.974 480.267 324.77 484.733 C 325.477 488.712 328.942 491.509 332.847 491.509 C 333.326 491.509 333.81 491.466 334.296 491.38 C 414.052 477.18 477.179 414.052 491.38 334.296 C 492.175 329.83 489.198 325.564 484.732 324.769 Z M 431.492 156.892 L 443.109 168.508 C 467.609 195.152 484.78 228.629 491.38 265.703 C 492.176 270.169 489.199 274.435 484.733 275.23 C 480.27 276.026 476.001 273.049 475.207 268.583 C 469.206 234.887 453.664 204.43 431.49 180.126 L 419.873 168.51 C 395.57 146.336 365.113 130.793 331.417 124.793 C 326.951 123.998 323.974 119.732 324.77 115.266 C 325.565 110.8 329.839 107.825 334.296 108.619 C 371.37 115.22 404.848 132.39 431.492 156.892 Z"/>
      <text style="fill: white; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 45.470986, 456.61146)"><tspan x="254.529" y="60.003">]]..damage..[[M</tspan></text>
      <text style="fill: #cf0c47; font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 44.105107, 38.795308)"><tspan x="254.529" y="36.003">]]..name..[[</tspan></text>
      <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px;" transform="matrix(1, 0, 0, 1, 241.470998, 244.195302)"><tspan x="254.529" y="36.003">KM/H</tspan></text>
      <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: end;" transform="matrix(1, 0, 0, 1, -154.09122, 244.195302)"><tspan x="254.529" y="36.003">]]..sdist..[[</tspan></text>
      <text style="fill: rgb(0, 191, 255); font-family: verdana; font-size: 26px; font-style: italic; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 43.882192, 510.395305)"><tspan x="254.529" y="36.003">DAMAGE</tspan></text>
      <text style="fill: #cf0c47; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: middle;" transform="matrix(1, 0, 0, 1, 45.470986, 44.611463)"><tspan x="254.529" y="60.003">]].. string.format("%03d", id%1000) ..[[</tspan></text>
      <text style="fill: white; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px; text-anchor: end;" y="310.246" x="101.677">]]..dist..[[</text>
      <text style="fill: ]]..speedcolor..[[; font-family: verdana; font-size: 26px; font-weight: 700; paint-order: stroke; stroke: rgb(0, 0, 0); stroke-width: 2px;" y="310.246" x="496">]]..speed .. znak..[[</text>
      </svg></div>]]
   end
else
   local pos1 = shipPos + 400000 * vec3(construct.getWorldOrientationForward())
   local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
   --local pos1 = ConvertLocalToWorld(0,distance,0)
   --local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
   if point1[3] > 0 then --visible zone
      local x2 = screenWidth*point1[1] - 100
      local y2 = screenHeight*point1[2] - 100
      sight = [[
      <style>
      .sight1 {
         position: absolute;
         width: 200px;
         height: 200px;
         left: ]]..x2..[[px;
         top: ]]..y2..[[px;
      }
      </style>
      <div class="sight1">
      <?xml version="1.0" encoding="utf-8"?>
      <svg viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xmlns="http://www.w3.org/2000/svg">
      <path style="fill: ]]..GHUD_AR_sight_color..[[;" d="M 231.231 440.732 C 230.524 444.711 227.058 447.508 223.154 447.508 C 222.675 447.508 222.191 447.465 221.705 447.379 C 141.949 433.179 78.822 370.052 64.621 290.296 C 63.825 285.83 66.802 281.564 71.268 280.769 C 75.729 279.975 80 282.95 80.794 287.416 C 93.793 360.422 151.578 418.207 224.583 431.205 C 229.051 432.001 232.026 436.266 231.231 440.732 Z M 71.268 231.231 C 71.754 231.318 72.239 231.36 72.717 231.36 C 76.621 231.36 80.087 228.563 80.794 224.584 C 93.793 151.578 151.578 93.793 224.583 80.795 C 229.049 80 232.026 75.734 231.23 71.269 C 230.435 66.802 226.166 63.829 221.704 64.622 C 141.948 78.822 78.821 141.949 64.62 221.705 C 63.825 226.171 66.802 230.436 71.268 231.231 Z M 440.732 280.769 C 436.273 279.976 432.001 282.951 431.206 287.416 C 418.207 360.422 360.422 418.208 287.417 431.206 C 282.951 432.001 279.974 436.267 280.77 440.733 C 281.477 444.712 284.942 447.509 288.847 447.509 C 289.326 447.509 289.81 447.466 290.296 447.38 C 370.052 433.18 433.179 370.052 447.38 290.296 C 448.175 285.83 445.198 281.564 440.732 280.769 Z M 387.492 112.892 L 399.109 124.508 C 423.609 151.152 440.78 184.629 447.38 221.703 C 448.176 226.169 445.199 230.435 440.733 231.23 C 436.27 232.026 432.001 229.049 431.207 224.583 C 425.206 190.887 409.664 160.43 387.49 136.126 L 375.873 124.51 C 351.57 102.336 321.113 86.793 287.417 80.793 C 282.951 79.998 279.974 75.732 280.77 71.266 C 281.565 66.8 285.839 63.825 290.296 64.619 C 327.37 71.22 360.848 88.39 387.492 112.892 Z"/>
      </svg></div>]]
   end
end
end

local AR_allies = ''
for k,v in pairs(radarIDs) do --AR marks
if radar.hasMatchingTransponder(v) == 1 then
   local pos = radar.getConstructWorldPos(v)
   local point = library.getPointOnScreen({pos[1],pos[2],pos[3]})
   if point[3] > 0 then --visible zone
      local x = screenWidth*point[1] - GHUD_AR_allies_border_size/2
      local y = screenHeight*point[2] - GHUD_AR_allies_border_size/2
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
      <text style="fill: ]]..GHUD_AR_allies_font_color..[[; font-family: Arial, sans-serif; font-size: 28px; font-weight: 700; text-anchor: middle;" transform="matrix(0.609174, 0, 0, 0.609176, 250.000005, 231)">]].. string.format("%03d", v%1000) .. [[</text>
      </svg></div>]]
   end
end
end

--hit/miss animations, radar contacts animations
local hitsHUD = ''
local missesHUD = ''
local targetsHUD = ''

for k,v in pairs(lastHitTime) do
   if lastHitTime[k] ~= nil then
      lastHitTime[k].time = lastHitTime[k].time + 0.025
      lastHitTime[k].hitOpacity = lastHitTime[k].hitOpacity - 0.01
      local top = 45 - lastHitTime[k].time*3.25
      local right = 56.5 + lastHitTime[k].time*2
      if lastHitTime[k].hitOpacity <= 0 then lastHitTime[k].hitOpacity = 0 end
      local hit = [[
      <style>
      .]]..tag..[[ {
         top: ]]..top..[[vh;
         left: ]]..right..[[%;
         position: absolute;
         text-alight: center;
         font-size: 40px;
         font-family: verdana;
         font-style: normal;
         font-weight: bold;
         color: #FFB12C;
         text-shadow: 4px 0 1px #FFB12C, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;
         opacity: ]]..lastHitTime[k].hitOpacity..[[;
         transform: translate(-50%, -50%);
      }
      </style>
      <div class="]]..tag..[[">HIT ]]..lastHitTime[k].damage..[[ HP</div>]]
      hits[tag] = {html = hit}
   
      if lastHitTime[k].time >= 2 then
         hits[tag] = {html = ''}
         if lastHitTime[k].anims == hitAnimations then
            hits[k] = nil
            hits = {}
            hitAnimations = 0
            lastHitTime = {}
         end
      end
   end
end

for k,v in pairs(lastMissTime) do
   if lastMissTime[k] ~= nil then
      lastMissTime[k].time = lastMissTime[k].time + 0.025
      lastMissTime[k].missOpacity = lastMissTime[k].missOpacity - 0.01
      local top = 45 - lastMissTime[k].time*3.25
      local left = 47.5 - lastMissTime[k].time*2
      if lastMissTime[k].missOpacity <= 0 then lastMissTime[k].missOpacity = 0 end
      local miss = [[
      <style>
      .]]..tag..[[ {
         top: ]]..top..[[vh;
         left: ]]..left..[[%;
         position: absolute;
         text-alight: center;
         font-size: 40px;
         font-family: verdana;
         font-style: normal;
         font-weight: bold;
         color: #fc033d;
         text-shadow: 4px 0 1px #fc033d, 0 1px 1px #000, -1px 0 1px #000, 0 -1px 1px #000;
         opacity: ]]..lastMissTime[k].missOpacity..[[;
         transform: translate(-50%, -50%);
      }
      </style>
      <div class="]]..tag..[[">MISS</div>]]
      misses[tag] = {html = miss}
   
      if lastMissTime[k].time >= 2 then
         misses[tag] = {html = ''}
         if lastMissTime[k].anims == missAnimations then
           misses[k] = nil
            misses = {}
            missAnimations = 0
            lastMissTime = {}
         end
      end
   end
end

for k,v in pairs(hits) do
   if hits[k] ~= nil then
hitsHUD = hitsHUD .. hits[k].html
   end
end

for k,v in pairs(misses) do
   if misses[k] ~= nil then
missesHUD = missesHUD .. misses[k].html
   end
end

for k,v in pairs(targets) do
   if target[k] ~= nil then
      if target[k].left > 80 and target[k].one == true then target[k].left = target[k].left - 0.3 end
      if target[k].left <= 80 then target[k].left = 80 target[k].one = false end
      local div = [[
         <style>
         .a]]..k..[[ {
         position: relative;
         color: black;
         top: 25vh;
         left: ]]..target[k].left..[[%;
         opacity: ]]..target[k].opacity..[[;
         background-color: ]]..GHUD_radar_notificafions_background..[[;
         border: 2px solid black;
         padding: 12px;
         margin-top: -2px;
         font-weight: bold;
         font-size: 20px;
         text-align: left;
         }
         </style>
         <div class="a]]..k..[[">[]]..target[k].size1..[[] ]]..target[k].id..[[ - ]]..target[k].name1..[[</div>]]
         target[k] = {html = div}
         if target[k].one == false then
            target[k].delay = target[k].delay + 1
            if target[k].delay >= 100 then
               target[k].opacity = target[k].opacity - 0.01
               --Mac os notifications style
               --if target[k].left <= 108 then target[k].left = target[k].left + 0.3 end
               --if target[k].opacity <= 0 and target[k].left >= 100 then
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

local htmlHUD = [[
   <html>
   <style>
   html,body {
      margin:0;
      padding:0;
      overflow: hidden;
   }
   </style>
   <body>
   ]]..AR_allies..[[
   ]]..vectorHUD..[[
   ]]..sight..[[
   ]]..missesHUD..[[
   ]]..hitsHUD..[[
   ]]..targetsHUD..[[   
   ]]..gunnerHUD..[[
   </body>
   </html>
]]

system.setScreen(htmlHUD)
