if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
    coroutine.resume(main1)
    --coroutine.xpcall(main) -- resume debug coroutine
end

radarIDs = radar.getConstructIds()
idN = #radarIDs

local sight = ''
if GHUD_AR_show_sight == true then --AR sight for selected target
    local id = radar.getTargetId()
    if id ~= 0 then
       --local distance = radar.getConstructDistance(id)
       local distance = 400000
       local shipPos = vec3(construct.getWorldPosition())
       local pos1 = shipPos + distance * vec3(construct.getWorldOrientationForward())
       local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
       --local pos1 = ConvertLocalToWorld(0,distance,0)
       --local point1 = library.getPointOnScreen({pos1.x,pos1.y,pos1.z})
       if point1[3] > 0 then --visible zone
          local x2 = screenWidth*point1[1] - GHUD_AR_sight_size/2
          local y2 = screenHeight*point1[2] - GHUD_AR_sight_size/2
          sight = [[
          <style>
          .sight {
             position: absolute;
             width: ]]..GHUD_AR_sight_size..[[px;
             height: ]]..GHUD_AR_sight_size..[[px;
             left: ]]..x2..[[px;
             top: ]]..y2..[[px;
          }
          </style>
          <div class="sight">
          <?xml version="1.0" encoding="utf-8"?>
          <svg viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xmlns="http://www.w3.org/2000/svg">
          <path style="fill: rgba(255, 255, 255, 0.5);" d="M 231.231 440.732 C 230.524 444.711 227.058 447.508 223.154 447.508 C 222.675 447.508 222.191 447.465 221.705 447.379 C 141.949 433.179 78.822 370.052 64.621 290.296 C 63.825 285.83 66.802 281.564 71.268 280.769 C 75.729 279.975 80 282.95 80.794 287.416 C 93.793 360.422 151.578 418.207 224.583 431.205 C 229.051 432.001 232.026 436.266 231.231 440.732 Z M 71.268 231.231 C 71.754 231.318 72.239 231.36 72.717 231.36 C 76.621 231.36 80.087 228.563 80.794 224.584 C 93.793 151.578 151.578 93.793 224.583 80.795 C 229.049 80 232.026 75.734 231.23 71.269 C 230.435 66.802 226.166 63.829 221.704 64.622 C 141.948 78.822 78.821 141.949 64.62 221.705 C 63.825 226.171 66.802 230.436 71.268 231.231 Z M 440.732 280.769 C 436.273 279.976 432.001 282.951 431.206 287.416 C 418.207 360.422 360.422 418.208 287.417 431.206 C 282.951 432.001 279.974 436.267 280.77 440.733 C 281.477 444.712 284.942 447.509 288.847 447.509 C 289.326 447.509 289.81 447.466 290.296 447.38 C 370.052 433.18 433.179 370.052 447.38 290.296 C 448.175 285.83 445.198 281.564 440.732 280.769 Z M 387.492 112.892 L 399.109 124.508 C 423.609 151.152 440.78 184.629 447.38 221.703 C 448.176 226.169 445.199 230.435 440.733 231.23 C 436.27 232.026 432.001 229.049 431.207 224.583 C 425.206 190.887 409.664 160.43 387.49 136.126 L 375.873 124.51 C 351.57 102.336 321.113 86.793 287.417 80.793 C 282.951 79.998 279.974 75.732 280.77 71.266 C 281.565 66.8 285.839 63.825 290.296 64.619 C 327.37 71.22 360.848 88.39 387.492 112.892 Z"/>
          </svg></div>]]
       end
    end
end

local AR_allies = ''
for k,v in pairs(radarIDs) do --AR marks
    if radar.hasMatchingTransponder(v) == 1 and GHUD_AR_allies_hold_only == false then
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
          <text style="fill: ]]..GHUD_AR_allies_font_color..[[; font-family: Arial, sans-serif; font-size: 28px; font-weight: 700; text-anchor: middle;" transform="matrix(0.609174, 0, 0, 0.609176, 250.000005, 231)">]].. v%1000 .. [[</text>
          </svg></div>]]
       end
    end
end

local hitsHUD = ''
local missesHUD = ''

for k,v in pairs(hits) do
    hitsHUD = hitsHUD .. hits[k].html
end

for k,v in pairs(misses) do
    missesHUD = missesHUD .. misses[k].html
end

system.setScreen(hudHTML .. missesHUD .. hitsHUD .. AR_allies .. sight)
