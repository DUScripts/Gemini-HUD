if coroutine.status(main1) ~= "dead" and coroutine.status(main1) == "suspended" then
    coroutine.resume(main1)
    --coroutine.xpcall(main) -- resume debug coroutine
end

radarIDs = radar.getConstructIds()
idN = #radarIDs

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

system.setScreen(hudHTML .. missesHUD .. hitsHUD .. AR_allies)
