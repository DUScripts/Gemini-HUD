-- GEMINI FOUNDATION

--Solo gunner seat
HUD_version = '1.0.0'

--LUA parameters
GHUD_friendly_IDs = {} -- put IDs here 34141,231231,31231 etc
GHUD_export_mode = false --export: Coordinate export mode
targetSpeed = 29999 --export: Target speed
GHUD_background_color = "#142027" --export:
GHUD_AR_sight_color = "rgb(0, 191, 255)" --export:
GHUD_weapon_panels = 3 --export:
--GHUD_radar_notifications_style = 1 --export:
GHUD_radar_notifications_border_radius = true --export:
GHUD_radar_notifications_border_color = 'black' --export:
GHUD_radar_notifications_text_color = 'black' --export:
GHUD_radar_notifications_background_color = 'rgb(255, 177, 44)' --export:
GHUD_radar_notifications_Y = 10 --export:
GHUD_log_stats = true --export: Send target statistics to LUA channel
GHUD_show_allies = true --export: Show allies
GHUD_allies_count = 5 --export: Count of displayed allies. Selected ally will always be displayed
GHUD_allies_color = "#0cf27b" --export:
GHUD_allied_names_color = "#0cf27b" --export:
GHUD_AR_allies_border_size = 400 --export:
GHUD_AR_allies_border_color = "#0cf27b" --export:
GHUD_AR_allies_font_color = "#0cf27b" --export:
GHUD_targets_color = "#fc033d" --export:
GHUD_show_echoes = true --export: Show targets echo
GHUD_notifications = true --export: Radar notifications + LUA char notification
GHUD_selected_border_color = "#00b9c9" --export:
GHUD_target_names_color = "#fc033d" --export: Color for target names
GHUD_allies_distance_color = "#00b9c9" --export:
GHUD_distance_color = "#00b9c9" --export:
GHUD_speed_color = "#00b9c9" --export:
GHUD_count_color = "#00b9c9" --export:
GHUD_your_ship_ID_color = "#fca503" --export:
GHUD_border_color = "black" --export:
GHUD_allies_Y = 0 --export: set to 0 if playing in fullscreen mode
GHUD_windowed_mode = false --export: adds 2 to the height GHUD_allies_Y
collectgarbages = true --export:

if GHUD_radar_notifications_border_radius == true then
   GHUD_border_radius = '15px'
else
   GHUD_border_radius = 'none'
end

GHUD_allies_count1 = GHUD_allies_count + 1

if GHUD_windowed_mode then
   GHUD_allies_Y = 2
end

--vars
atlas = require("atlas")
shift = false
lalt = false
radarIDs = {}
idN = 0
screenHeight = system.getScreenHeight()
screenWidth = system.getScreenWidth()
startTime = system.getArkTime()
lastHitTime = {}
lastMissTime = {}
hits = {}
misses = {}
hitAnimations = 0
missAnimations = 0
totalDamage = {}
mRadar = {}
mWeapons = {}
size = {'XL','L','M','S','XS','ALL'}
defaultSize = 'ALL'
sizeState = 6
focus = ''
gunnerHUD = ''
vectorHUD = ''
sight = ''
buttonSpace = false
buttonC = false
atmovar = false
speedcolor = ""
endload = 0
lastspeed = 0
znak = '' --target speed icon
firstload = 0
constructSelected = 0
probil = 0
playerName = system.getPlayerName(player.getId())
shipPos = vec3(construct.getWorldPosition())
warpScan = 0 --for 3D map
t_radarEnter = {}
loglist = {}
radarTarget = nil
radarStatic = {}
radarDynamic = {}
radarStaticWidget = {}
radarStaticData = {}
radarDynamicWidget = {}
radarDynamicData = {}
radarWidget = ''
targets = {}
target = {}
count = 0
shipName = construct.getName()
local scID = construct.getId()
system.print(''..shipName..': '..scID..'')
conID = tostring(scID):sub(-3)

function checkWhitelist()
   local whitelist = GHUD_friendly_IDs
   local set = {}
   for _, l in ipairs(whitelist) do set[l] = true end
   return set
end

whitelist = checkWhitelist() --load IDs
local pauseAfter = 500 --radar widget coroutine

--radar widget
function defaultRadar()
   sizeState = 6
   defaultSize = 'ALL'
   if mRadar.friendlyMode == true then mRadar.friendlyMode = false end
end

function mRadar:createWidget()
   self.dataID = self.system.createData(self.radar.getWidgetData())
   radarPanel = self.system.createWidgetPanel('')
   radarWidget = self.system.createWidget(radarPanel, self.radar.getWidgetType())
   self.system.addDataToWidget(self.dataID, radarWidget)
end

function mRadar:createWidgetNew()
   self.dataID = self.system.createData(self.radar.getWidgetData())
   radarWidget = self.system.createWidget(radarPanel, self.radar.getWidgetType())
   self.system.addDataToWidget(self.dataID, radarWidget)
end

function mRadar:deleteWidget()
   self.system.destroyData(self.dataID)
   self.system.destroyWidget(radarWidget)
end

function mRadar:updateLoop()
   while true do
      self:updateStep()
      coroutine.yield()
   end
end

function mRadar:updateStep()
   local resultList = {}
   local data = self.radar.getWidgetData()
   local constructList = data:gmatch('({"constructId":".-%b{}.-})')
   local isIDFiltered = next(self.idFilter) ~= nil
   local i = 0
   for str in constructList do
      i = i + 1
      if i%pauseAfter==0 then
         coroutine.yield()
      end
      local ID = tonumber(str:match('"constructId":"([%d]*)"'))
      local size = self.radar.getConstructCoreSize(ID)
      local locked = self.radar.isConstructIdentified(ID)
      local alive = self.radar.isConstructAbandoned(ID)
      local selectedTarget = self.radar.getTargetId(ID)
      if locked == 1 or alive == 0 or selectedTarget == ID and size ~= "" then --show only locked or alive or selected targets
         if defaultSize == 'ALL' then --default mode
            if (self.friendList[ID]==true or self.radar.hasMatchingTransponder(ID)==1) ~= self.friendlyMode and self.radar.getThreatRateFrom(ID) ~= 5 then  --show attacking traitor on widget
               goto continue1
            end
            if isIDFiltered and self.idFilter[ID%1000] ~= true then
               goto continue1
            end
            resultList[#resultList+1] = str:gsub('"name":"(.+)"', '"name":"' .. tostring(ID):sub(-3) .. ' - %1"')
            ::continue1::
         end
         if defaultSize ~= 'ALL' and size == defaultSize then --sorted
            if (self.friendList[ID]==true or self.radar.hasMatchingTransponder(ID)==1) ~= self.friendlyMode and self.radar.getThreatRateFrom(ID) ~= 5 then
               goto continue2
            end
            if isIDFiltered and self.idFilter[ID%1000] ~= true then
               goto continue2
            end
            resultList[#resultList+1] = str:gsub('"name":"(.+)"', '"name":"' .. tostring(ID):sub(-3) .. ' - %1"')
            ::continue2::
         end
      end
   end
   local filterMsg = (isIDFiltered and ''..focus..' - FOCUS - ' or '') .. (self.friendlyMode and ''..defaultSize..' - Friends' or ''..defaultSize..' - Enemies')
   --local postData = data:match('"elementId":".+') --deprecated
   local postData = data:match('"currentTargetId":".+')
   postData = postData:gsub('"errorMessage":""', '"errorMessage":"' .. filterMsg .. '"') --filter data
   data = '{"constructsList":[' .. table.concat(resultList, ",") .. "]," .. postData --completed json radar data
   self.system.updateData(self.dataID, data)
end

function mRadar:onUpdate()
   coroutine.resume(self.updaterCoroutine)
end

function mRadar:clearIDFilter()
   self.idFilter = {}
end

function mRadar:addIDFilter(id)
   self.idFilter[id] = true
end

--pvp focus mode
function mRadar:onTextInput(text)
   self:clearIDFilter()
   focus = text:sub(-3)
   defaultRadar()
   for id in text:gmatch('%D(%d%d%d)') do
      self:addIDFilter(tonumber(id))
   end
end

function mRadar:toggleFriendlyMode()
   self.friendlyMode = not self.friendlyMode
end

function mRadar:new(sys, radar, friendList)
   local mRadar = {}
   setmetatable(mRadar, self)
   self.system = sys
   self.radar = radar
   self.friendlyMode = false
   self.friendList = friendList or {}
   self.onlyIdentified = false
   self.idFilter = {}
   --self:createWidget()
   self.dataID = self.system.createData(self.radar.getWidgetData())
   self.radarPanel = self.system.createWidgetPanel('')
   self.radarWidget = self.system.createWidget(self.radarPanel, self.radar.getWidgetType())
   self.system.addDataToWidget(self.dataID, self.radarWidget)
   self.updaterCoroutine = coroutine.create(function() self:updateLoop() end)
   return self
end

function mRadar:stopC()
   self:clearIDFilter(self.system.print("FOCUS MODE DEACTIVATED"))
end

--weapon widgets
local oldAnimationTime = {}
local oldWeaponStatus = {}
local oldFireReady = {}
local OldoutOfZone = {}
local oldTargetConstruct = {}
local oldHitProbability = {}

function mWeapons:createWidgets()
   if not (type(self.weapons) == 'table' and #self.weapons > 0) then
      return
   end
   local widgetPanelID
   for i, weap in ipairs(self.weapons) do
      if (i-1) % self.weaponsPerPanel == 0 then
         widgetPanelID = self.system.createWidgetPanel('')
      end
      local weaponDataID = self.system.createData(weap.getWidgetData())
      self.weaponData[weaponDataID] = weap
      oldAnimationTime[weaponDataID] = 0
      self.system.addDataToWidget(weaponDataID, self.system.createWidget(widgetPanelID, weap.getWidgetType()))
   end
end

function mWeapons:onUpdate()
   for weaponDataID, weap in pairs(self.weaponData) do
      local weaponData = weap.getWidgetData()
      local weaponStatus = weaponData:match('"weaponStatus":(%d+)')
      local animationTime = tonumber(weaponData:match('"cycleAnimationRemainingTime":(.-),'))
      local fireReady = weaponData:match('"fireReady":(.-),')
      local outOfZone = weaponData:match('"outOfZone":(.-),')
      local targetConstructID = weaponData:match('"constructId":"(.-)"')
      local hitProbability = weaponData:match('"hitProbability":(.-),')
      local hitP = math.ceil(tonumber(hitProbability) * 100)
      local animationChanged = animationTime > oldAnimationTime[weaponDataID]
      oldAnimationTime[weaponDataID] = animationTime

      if weaponStatus == oldWeaponStatus[weaponDataID] and oldTargetConstruct[weaponDataID] == targetConstructID and oldFireReady[weaponDataID] == fireReady and OldoutOfZone[weaponDataID] == outOfZone and oldHitProbability[weaponDataID] == hitProbability and not animationChanged then
         goto continue
      end
      oldWeaponStatus[weaponDataID] = weaponStatus
      oldFireReady[weaponDataID] = fireReady
      OldoutOfZone[weaponDataID] = outOfZone
      oldTargetConstruct[weaponDataID] = targetConstructID
      oldHitProbability[weaponDataID] = hitProbability

      local ammoName = weaponData:match('"ammoName":"(.-)"')

      local ammoType1 = ""
      if ammoName:match("Antimatter") then
         ammoType1 = "AM"
      elseif ammoName:match("Electromagnetic") then
         ammoType1 = "EM"
      elseif ammoName:match("Kinetic") then
         ammoType1 = "KI"
      elseif ammoName:match("Thermic") then
         ammoType1 = "TH"
      elseif ammoName:match("Stasis") then
         ammoType1 = "Stasis"
      end

      local ammoType2 = ""
      if ammoName:match("Precision") then
         ammoType2 = "Prec"
      elseif ammoName:match("Heavy") then
         ammoType2 = "Heavy"
      elseif ammoName:match("Agile") then
         ammoType2 = "Agile"
      elseif ammoName:match("Defense") then
         ammoType2 = "Def"
      end

      --weaponData = weaponData:gsub('"ammoName":"(.-)"', '"ammoName":"' .. hitP .. '% ' .. ammoType1 .. ' ' .. ammoType2 .. '"')
      --weaponData = weaponData:gsub('"constructId":"(%d+(%d%d%d))","name":"(.?.?.?.?).-"', '"constructId":"%1","name":"%2 - %3"')
      weaponData = weaponData:gsub('"ammoName":"(.-)"', '"ammoName":"' .. hitP .. '%% - ' .. ammoType1 .. ' ' .. ammoType2 .. '"')
      weaponData = weaponData:gsub('"constructId":"(%d+(%d%d%d))","name":"(.?.?.?.?.?.?.?.?.?.?.?.?.?.?).-"', '"constructId":"%1","name":"%2 - %3"')

      if self.system.updateData(weaponDataID, weaponData) ~= 1 then
         self.system.print('update error')
      end

      ::continue::
   end
end

function mWeapons:new(sys, weapons, weaponsPerPanel)
   local mWeapons = {}
   setmetatable(mWeapons, self)
   self.system = sys
   self.weapons = weapons
   self.weaponsPerPanel = weaponsPerPanel or 3
   self.weaponData = {}
   self:createWidgets()
   return self
end

--debug coroutine
function coroutine.xpcall(co)
   local output = {coroutine.resume(co)}
   if output[1] == false then
      local tb = traceback(co)

      local message = tb:gsub('"%-%- |STDERROR%-EVENTHANDLER[^"]*"', 'chunk')
      system.print(message)

      message = output[2]:gsub('"%-%- |STDERROR%-EVENTHANDLER[^"]*"', 'chunk')
      system.print(message)
      return false, output[2], tb
   end
   return table.unpack(output)
end

function ConvertLocalToWorld(x,y,z)
   local xOffset = x * vec3(construct.getWorldRight())
   local yOffset = y * vec3(construct.getWorldForward())
   local zOffset = z * vec3(construct.getWorldUp())

   return xOffset + yOffset + zOffset + vec3(construct.getWorldPosition())
end

--Echoes startup configurator
-- if radar_1.getOperationalState() == 0 then
--    radarWidgetScale = 160
--    radarWidgetScaleDisplay = '<div class="measures"><span>0 KM</span><span>2.5 KM</span><span>5 KM</span></div>'
-- else
--    radarWidgetScale = 2
--    radarWidgetScaleDisplay = '<div class="measures"><span>0 SU</span><span>1 SU</span><span>2 SU</span></div>'
-- end

radarWidgetScale = 2
radarWidgetScaleDisplay = '<div class="measures"><span>0 SU</span><span>1 SU</span><span>2 SU</span></div>'

radar_1.setSortMethod(1) --set default radar range mode for constructIds list main function

mWeapons = mWeapons:new(system, weapon, GHUD_weapon_panels) --weapon widgets
mRadar = mRadar:new(system, radar_1, whitelist) --radar widget

system.showScreen(1)
unit.setTimer("radar",0.05)

--main gunner function
function main()
   while true do
      local i = 0
      local htmltext = ""
      local hudver = ""
      local htmltext2 = ""
      local friendlies = 0
      local countLock = 0
      local countAttacked = 0
      local list, list2, lockList = "", "", ""
      local islockList = ""
      local caption = ""
      local captionL = ""
      local target1 = ""
      local locks = ""
      local statusSVG = ""
      local captionText = ""
      local okcolor = ""
      local captionLcolor = ""
      radarTarget = {}
      radarStatic = {}
      radarDynamic = {}
      radarDynamicData = radarDynamicWidget
      radarDynamicWidget = {}
      radarStaticData = radarStaticWidget
      radarStaticWidget = {}
      for k,v in pairs(radarIDs) do
         i = i + 1
         local size = radar_1.getConstructCoreSize(v)
         local constructRow = {}
         if GHUD_log_stats then
            if t_radarEnter[v] ~= nil then
               if radar_1.hasMatchingTransponder(v) == 0 and not whitelist[v] and size ~= "" and radar_1.getConstructDistance(v) < 600000 then --do not show far targets during warp and server lag
                  local name = radar_1.getConstructName(v)
                  if radar_1.isConstructAbandoned(v) == 0 then
                     local msg = 'NEW TARGET: '..name..' - '..v..' - Size: '..size..'\nYour pos: '..t_radarEnter[v].pos..''
                     table.insert(loglist, msg)
                     if count < 10 then --max 10 notifications
                        count = count + 1
                        if target[count] == nil then
                           target[count] = {left = 100, opacity = 1, name1 = name, size1 = size, id = tostring(v):sub(-3), one = true, check = true, delay = 0}
                        end
                        system.playSound('enter.mp3')
                     end
                  else
                     local pos = radar_1.getConstructWorldPos(v)
                     pos = '::pos{0,0,'..pos[1]..','..pos[2]..','..pos[3]..'}'
                     local msg = 'NEW TARGET (abandoned): '..name..' - '..v..' - Size: '..size..'\nTarget pos:'..pos..''
                     table.insert(loglist, msg)
                     if count < 10 then --max 10 notifications
                        count = count + 1
                        if target[count] == nil then
                           target[count] = {left = 100, opacity = 1, name1 = name, size1 = size, id = tostring(v):sub(-3), one = true, check = true, delay = 0}
                        end
                     end
                     system.playSound('sonar.mp3')
                  end
               end
               t_radarEnter[v] = nil
            end
         end
         if GHUD_show_echoes == true and size ~= "" then
            constructRow.widgetDist = math.ceil(radar_1.getConstructDistance(v) / 1000 * radarWidgetScale)
         end
         --radarlist
         if GHUD_show_allies == true and size ~= "" then
            if radar_1.hasMatchingTransponder(v) == 1 or whitelist[v] and radar_1.getThreatRateFrom(v) ~= 5 then  --remove attacking traitor from the allies HUD
               local name = radar_1.getConstructName(v)
               local dist = math.floor(radar_1.getConstructDistance(v))
               if dist >= 1000 then
                  dist = ''..string.format('%0.1f', dist/1000)..'km ('..string.format('%0.2f', dist/200000)..'SU)'
               else
                  dist = ''..dist..'m'
               end
               local allID = tostring(v):sub(-3)
               local nameA = ''..allID..' '..name..''
               friendlies = friendlies + 1
               if radar_1.getTargetId(v) ~= v and friendlies < GHUD_allies_count1 then
                  list = list..[[
                  <div class="table-row3 th3">
                  <div class="table-cell3">
                  ]]..'['..size..'] '..nameA.. [[<br><distalliescolor>]] ..dist.. [[</distalliescolor>
                  </div>
                  </div>]]
               end
               if radar_1.getTargetId(v) == v and friendlies < GHUD_allies_count1 then
                  list = list..[[
                  <div class="table-row3 th3S">
                  <div class="table-cell3S">
                  ]]..'['..size..'] '..nameA.. [[<br><distalliescolor>]] ..dist.. [[</distalliescolor>
                  </div>
                  </div>]]
               end
               if radar_1.getTargetId(v) == v and friendlies >= GHUD_allies_count1 then
                  list = list..[[
                  <div class="table-row3 th3S">
                  <div class="table-cell3S">
                  ]]..'['..size..'] '..nameA.. [[<br><distalliescolor>]] ..dist.. [[</distalliescolor>
                  </div>
                  </div>]]
               end
            end
         end
         --targets
         local speed = 0
         local radspeed = 0
         local angspeed = 0
         if radar_1.isConstructIdentified(v) == 1 and size ~= "" then
            local name = string.sub((""..radar_1.getConstructName(v)..""),1,11)
            local dist = math.floor(radar_1.getConstructDistance(v))
            if dist >= 1000 then
               dist = ''..string.format('%0.1f', dist/1000)..'km ('..string.format('%0.2f', dist/200000)..'SU)'
            else
               dist = ''..dist..'m'
            end
            local IDT = tostring(v):sub(-3)
            local nameIDENT = ''..IDT..' '..name..''
            --local nameT = string.sub((""..nameIDENT..""),1,11)
            --table.insert(radarTarget, constructRow)
            isILock = true
            speed = math.floor(radar_1.getConstructSpeed(v) * 3.6)
            if radar_1.getTargetId(v) == v then
               islockList = islockList..[[
               <div class="table-row2 thS">
               <div class="table-cellS">
               ]]..'['..size..'] '..nameIDENT.. [[ <speedcolor> ]] ..speed.. [[km/h</speedcolor><br><distcolor>]] ..dist.. [[</distcolor>
               </div>
               </div>]]
            else
               islockList = islockList..[[
               <div class="table-row2 th2">
               <div class="table-cell2">
               ]]..'['..size..'] '..nameIDENT.. [[ <speedcolor> ]] ..speed.. [[km/h</speedcolor><br><distcolor>]] ..dist.. [[</distcolor>
               </div>
               </div>]]
            end
         else

            if GHUD_show_echoes == true and size ~= "" then
               if radar_1.getConstructKind(v) == 5 then
                  table.insert(radarDynamic, constructRow)
                  if radarDynamicWidget[constructRow.widgetDist] ~= nil then
                     radarDynamicWidget[constructRow.widgetDist] = radarDynamicWidget[constructRow.widgetDist] + 1
                  else
                     radarDynamicWidget[constructRow.widgetDist] = 1
                  end
               else
                  table.insert(radarStatic, constructRow)
                  if radarStaticWidget[constructRow.widgetDist] ~= nil then
                     radarStaticWidget[constructRow.widgetDist] = radarStaticWidget[constructRow.widgetDist] + 1
                  else
                     radarStaticWidget[constructRow.widgetDist] = 1
                  end
               end
            end
         end
         --lockstatus
         if radar_1.getThreatRateFrom(v) ~= 1 and size ~= "" then
            countLock = countLock + 1
            local name = radar_1.getConstructName(v)
            local dist = math.floor(radar_1.getConstructDistance(v))
            if dist >= 1000 then
               dist = ''..string.format('%0.1f', dist/1000)..'km ('..string.format('%0.2f', dist/200000)..'SU)'
            else
               dist = ''..dist..'m'
            end
            local loclIDT = tostring(v):sub(-3)
            local nameLOCK = ''..loclIDT..' '..name..''
            if radar_1.getThreatRateFrom(v) == 5 then
               countAttacked = countAttacked + 1
               lockList = lockList..[[
               <div class="table-row th">
               <div class="lockedT">
               <redcolor1>]]..'['..size..'] '..nameLOCK.. [[</redcolor1><br><distcolor>]] ..dist.. [[</distcolor>
               </div>
               </div>]]
            else
               lockList = lockList..[[
               <div class="table-row th">
               <div class="lockedT">
               <orangecolor>]]..'['..size..'] '..nameLOCK.. [[</orangecolor><br><distcolor>]] ..dist.. [[</distcolor>
               </div>
               </div>]]
            end
         end
         if i > 50 then
            i = 0
            coroutine.yield()
         end
      end
      if GHUD_show_allies == true then
         if friendlies > 0 then
            caption = "<alliescolor>Allies:</alliescolor><br><countcolor>"..friendlies.."</countcolor> <countcolor2>"..conID.."</countcolor2>"
         else
            caption = "<alliescolor>Allies:</alliescolor><br><countcolor>0</countcolor> <countcolor2>"..conID.."</countcolor2>"
         end
         htmltext = htmlbasic .. [[
         <style>
         .th3>.table-cell3 {
            color: ]]..GHUD_allied_names_color..[[;
            font-weight: bold;
         }
         </style>
         <div class="table3">
         <div class="table-row3 th3">
         <div class="table-cell3">
         ]]..caption..[[
         </div>
         </div>
         ]]..list..[[
         </div>]]
      end
      caption = "<targetscolor>Targets:</targetscolor>"
      target1 = targetshtml .. [[
      <style>
      .th2>.table-cell2 {
         color: ]]..GHUD_target_names_color..[[;
         font-weight: bold;
      }
      </style>
      <div class="table2">
      <div class="table-row2 th2">
      <div class="table-cell2">
      ]] .. caption .. [[<br><countcolor>]]..idN-friendlies..[[</colorcount>
      </div>
      </div>
      ]] .. islockList .. [[
      </div>]]
      --threat status
      if countLock == 0 then
         captionL = "LOCK"
         captionLcolor = "#6affb1"
         captionText = "OK"
         okcolor = captionLcolor
      else
         captionL = "LOCKED:"
         captionLcolor = "#fca503"
         captionText = countLock
         okcolor = "#2ebac9"
      end
      --attackers count
      if countAttacked > 0 then
         captionL = "ATTACKED:"
         captionLcolor = "#fc033d"
         captionText = countAttacked
         okcolor = "#2ebac9"
      end
      --threat icon
      statusSVG = [[<style>.radarLockstatus {
         position: fixed;
         background: transparent;
         width: 6em; 
         padding: 1vh;
         top: 13.5vh;
         left: 50%;
         transform: translateX(-50%);
         text-align: center;
         fill: ]]..captionLcolor..[[;
      }
      svg text{
         text-anchor: middle;
         dominant-baseline: middle;
         font-size: 110px;
         font-weight: bold;
         fill: ]]..okcolor..[[;
      }
      </style>
      <div class="radarLockstatus">
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" xmlns:xlink="http://www.w3.org/1999/xlink" enable-background="new 0 0 512 512">
      <g>
      <path d="m501,245.6h-59.7c-5.3-93.9-81-169.6-174.9-174.9v-59.7h-20.9v59.7c-93.8,5.3-169.5,81-174.8,174.9h-59.7v20.9h59.7c5.3,93.8 81,169.5 174.9,174.8v59.7h20.9v-59.7c93.9-5.3 169.6-80.9 174.8-174.8h59.7v-20.9zm-80.6,0h-48.1c-4.9-56.3-49.6-100.9-105.9-105.9v-48.1c82.5,5.2 148.8,71.5 154,154zm-69.1,20.8c-4.9,44.7-40.9,80-84.9,84.9v-31.7h-20.9v31.8c-44.8-4.8-80.1-40.1-84.9-84.9h31.8v-20.9h-31.7c4.9-44.7 40.9-80 84.9-84.9v31.7h20.9v-31.7c44,4.9 80,40.2 84.9,84.9h-31.7v20.9h31.6zm-105.7-174.9v48.1c-56.3,4.9-100.9,49.6-105.9,105.9h-48.1c5.2-82.5 71.5-148.8 154-154zm-154,174.8h48.1c4.9,56.3 49.6,100.9 105.9,105.9v48.1c-82.5-5.2-148.8-71.5-154-154zm174.8,154v-48.1c56.3-4.9 100.9-49.6 105.9-105.9h48.1c-5.2,82.5-71.5,148.8-154,154z"/>
      </g>
      <text x="50%" y="52%">]]..captionText..[[</text>
      </svg>
      </div>]]
      locks = lockhtml .. [[
      <style>
      .th>.table-cell {
         font-weight: bold;
      }
      </style>
      <div class="table">
      <div class="table-row th">
      <div class="table-cell">
      <rightlocked style="color: ]]..captionLcolor..[[;">]] .. captionL  .. [[</rightlocked>
      </div>
      </div>
      ]] .. lockList .. [[
      </div>]]
      --Echoes widget
      if GHUD_show_echoes == true then
         local dynamic = ''
         for k,v in pairs(radarDynamicData) do
            dynamic = dynamic .. '<span style="left:'..k..'px;height:'..v..'px;"></span>'
         end
         local static = ''
         for k,v in pairs(radarStaticData) do
            static = static .. '<span style="left:'..k..'px;height:'..v..'px;"></span>'
         end
         local htmlRadar = htmlRadar .. [[
         <div class="radar-widget">
         <div class="d-widget">]] .. dynamic .. [[</div>
         <div class="s-widget">]] .. static .. [[</div>
         <div class="labels">
         <span style="color: #6fc9ff;">DYNAMIC</span>
         <span style="color: #ff8d00;">STATIC</span>
         </div>
         ]]..radarWidgetScaleDisplay..[[
         </div>
         ]]
         radarWidget = htmlRadar
      else
         radarWidget = ''
      end

      hudver = hudvers .. [[<div class="hudversion">GHUD v]]..HUD_version..[[</div>]]

      if GHUD_show_echoes == true then
         if GHUD_show_allies == true then
            --system.setScreen(htmltext .. target1 .. locks .. hudver .. radarWidget ..statusSVG)
            gunnerHUD = htmltext .. target1 .. locks .. hudver .. radarWidget ..statusSVG
         else
            --system.setScreen(target1 .. locks .. hudver .. radarWidget ..statusSVG)
            gunnerHUD = target1 .. locks .. hudver .. radarWidget ..statusSVG
         end

      else

         if GHUD_show_allies == true then
            --system.setScreen(htmltext .. target1 .. locks .. hudver ..statusSVG)
            gunnerHUD = htmltext .. target1 .. locks .. hudver ..statusSVG
         else
            --system.setScreen(target1 .. locks .. hudver ..statusSVG)
            gunnerHUD = target1 .. locks .. hudver ..statusSVG
         end
      end
      coroutine.yield()
   end
end

--HUD design
lockhtml = [[<style>
.table {
   display: table;
   background: ]]..GHUD_background_color..[[;
   left: 0;
   top: 5vh;
   position: fixed;
}
.table-row {
   display: table-row;
}
.table-cell {
   display: table-cell;
   padding: 6px;
   border: 1px solid ]]..GHUD_border_color..[[;
   color: white;
}
.lockedT {
   display: table-cell;
   padding: 6px;
   border: 1px solid ]]..GHUD_border_color..[[;
   border-top: none;
   color: white;
}
orangecolor {
   color: #fca503;
}
redcolor1 {
   color: #fc033d;
}
rightlocked {
}</style>]]
targetshtml = [[<style>
.table2 {
   display: table;
   background: ]]..GHUD_background_color..[[;
   position: fixed;
   top: 0;
   left: 0;
}
.table-row2 {
   display: table-row;
   float: left;
}
.table-cell2 {
   display: table-cell;
   padding: 6px;
   border: 1px solid ]]..GHUD_border_color..[[;
   color: white;
}
.table-cellS {
   display: table-cell;
   padding: 6px;
   border: 1px solid ]]..GHUD_selected_border_color..[[;
   color: white;
}
.thS>.table-cellS {
   color: ]]..GHUD_target_names_color..[[;
   font-weight: bold;
}
distcolor {
   font-weight: bold;
   color: ]]..GHUD_distance_color..[[;
}
distalliescolor {
   font-weight: bold;
   color: ]]..GHUD_allies_distance_color..[[;
}
speedcolor {
   font-weight: bold;
   color: ]]..GHUD_speed_color..[[;
   outline: 1px inset black;
}
countcolor {
   font-weight: bold;
   color: ]]..GHUD_count_color..[[;
}
countcolor2 {
   font-weight: bold;
   color: ]]..GHUD_your_ship_ID_color..[[;
   float: right;
}
chancecolor {
   color: #6affb1;
}
targetscolor {
   color: ]]..GHUD_targets_color..[[;
}
alliescolor {
   color: ]]..GHUD_allies_color..[[;
}
.txgrenright {
   font-weight: bold;
   text-align: right;
   color: #0cf27b;
}
</style>]]
htmlbasic = [[<style>
.table3 {
   display: table;
   background: ]]..GHUD_background_color..[[;
   font-weight: bold;
   position: fixed;
   bottom: ]]..GHUD_allies_Y..[[vh;
   left: 0;
}
.table-row3 {
   display: table-row;
   float: left;
}
.table-cell3 {
   display: table-cell;
   padding: 5px;
   border: 1px solid ]]..GHUD_border_color..[[;
   color: white;
   font-weight: bold;
}
.table-cell3S {
   display: table-cell;
   padding: 5px;
   border: 1px solid ]]..GHUD_selected_border_color..[[;
   color: white;
}
.th3S>.table-cell3S {
   color: ]]..GHUD_allied_names_color..[[;
   font-weight: bold;
}</style>]]
hudvers = [[
<style>
.hudversion {
   position: fixed;
   bottom: 2.7vh;
   color: white;
   right: 9.25vw;
   font-family: v;
   letter-spacing: 0.5px;
   font-size: 1.4em;
   font-weight: bold;
}</style>]]

htmlRadar = [[
<style>
.radar-widget {
   width: 800px;
   height: 50px;
   position: absolute;
   margin-left: auto;
   margin-right: auto;
   left: 0;
   right: 0;
   top: 8vh;
   background: radial-gradient(60% 50% at 50% 50%, rgba(60, 166, 255, .34), transparent);
   border-right: 1px solid;
   border-left: 1px solid;
   transform-style: preserve-3d;
   transform-origin: top;
   transform: perspective(120px) rotateX(-4deg);
}
.d-widget,
.s-widget {
   height: 25px;
   width: 100%;
   overflow: hidden;
   position: relative;
}
.s-widget {
   border-top: 1px solid;
}
.d-widget span {
   background: linear-gradient(0deg, #b6ddff, #3ea7ff 25px);
   width: 2px;
   bottom: 0;
   position: absolute;
}
.s-widget span {
   background: linear-gradient(180deg, #ffd322, #ff7600 25px);
   width: 2px;
   top: 0;
   position: absolute;
}
.measures {
   display: flex;
   justify-content: space-between;
   font-size: 20px;
}
.measures span:first-child {
   transform: translateX(-50%);
}
.measures span:last-child {
   transform: translateX(50%);
}
.labels {
   display: flex;
   flex-direction: column;
   position: absolute;
   right: -60px;
   top: 0;
   height: 100%;
   justify-content: space-evenly;
   font-size: 12px;
}
.con-size {
   width: 20px;
   text-align: center;
   background: #235f92;
   margin-right: 4px;
   color: white;
   height: 18px;
}
.warp-scan {
   width: 15px;
   height: 15px;
   border-radius: 50%;
   box-sizing: border-box;
   background: #ff3a56;
}
</style>]]

--interception concept, be careful
--Dear programmer:
--When I wrote this code, only God and I know how the next code works, don't try to edit it!

function zeroConvertToWorldCoordinates(pos, system)
   local num = " *([+-]?%d+%.?%d*e?[+-]?%d*)"
   local posPattern = "::pos{" .. num .. "," .. num .. "," .. num .. "," .. num .. "," .. num .. "}"
   local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)

   if systemId == nil or bodyId == nil or latitude == nil or longitude == nil or altitude == nil then
      system.print("Invalid POS!")
      return vec3()
   end

   if (systemId == "0" and bodyId == "0") then
      --convert space bm
      return vec3(latitude, longitude, altitude)
   end
   longitude = math.rad(longitude)
   latitude = math.rad(latitude)
   local planet = atlas[tonumber(systemId)][tonumber(bodyId)]
   local xproj = math.cos(latitude)
   local planetxyz = vec3(xproj * math.cos(longitude), xproj * math.sin(longitude), math.sin(latitude))
   return vec3(planet.center) + (planet.radius + altitude) * planetxyz
end

function getPipeD(system)
   if databank_1.getStringValue(1) ~= "" and databank_1.getStringValue(3) ~= "" then
      local distanceS = ""

      local length1 = -700 * 200000
      local length2 = 800 * 200000

      local pos123 = pos1
      local pos234 = pos2

      local pos111 = zeroConvertToWorldCoordinates(pos123, system)
      local pos222 = zeroConvertToWorldCoordinates(pos234, system)

      local DestinationCenter = vectorLengthen(pos111, pos222, length1)
      local DepartureCenter = vectorLengthen(pos111, pos222, length2)

      local worldPos = vec3(construct.getWorldPosition())
      local pipe = (DestinationCenter - DepartureCenter):normalize()
      local r = (worldPos - DepartureCenter):dot(pipe) / pipe:dot(pipe)
      if r <= 0. then
         return (worldPos - DepartureCenter):len()
      elseif r >= (DestinationCenter - DepartureCenter):len() then
         return (worldPos - DestinationCenter):len()
      end
      local L = DepartureCenter + (r * pipe)
      local distance = (L - worldPos):len()
      if distance < 1000 then
         distanceS = "" .. string.format("%0.0f", distance) .. " m"
      elseif distance < 100000 then
         distanceS = "" .. string.format("%0.1f", distance / 1000) .. " km"
      else
         distanceS = "" .. string.format("%0.2f", distance / 200000) .. " su"
      end
      return distanceS
   end
end

function getPipeW(system)
   if databank_1.getStringValue(1) ~= "" and databank_1.getStringValue(3) ~= "" then
      showMarker = false

      local length1 = -700 * 200000
      local length2 = 800 * 200000

      local pos123 = pos1
      local pos234 = pos2

      local pos111 = zeroConvertToWorldCoordinates(pos123, system)
      local pos222 = zeroConvertToWorldCoordinates(pos234, system)

      local DestinationCenter = vectorLengthen(pos111, pos222, length1)
      local DepartureCenter = vectorLengthen(pos111, pos222, length2)

      local worldPos = vec3(construct.getWorldPosition())
      local pipe = (DestinationCenter - DepartureCenter):normalize()
      local r = (worldPos - DepartureCenter):dot(pipe) / pipe:dot(pipe)
      if r <= 0. then
         return (worldPos - DepartureCenter):len()
      elseif r >= (DestinationCenter - DepartureCenter):len() then
         return (worldPos - DestinationCenter):len()
      end
      local L = DepartureCenter + (r * pipe)
      local PipeWaypoint = "::pos{0,0," .. math.floor(L.x) .. "," .. math.floor(L.y) .. "," .. math.floor(L.z) .. "}"
      system.print("Pipe center")
      system.setWaypoint(PipeWaypoint)
   end
end

function getPos4Vector(coordinate)
   return "::pos{0,0," .. vec3(coordinate).x .. "," .. vec3(coordinate).y .. "," .. vec3(coordinate).z .. "}"
end

-- делает вектор из двух координат
function makeVector(coordinateBegin, coordinateEnd)
   local x = vec3(coordinateEnd).x - vec3(coordinateBegin).x
   local y = vec3(coordinateEnd).y - vec3(coordinateBegin).y
   local z = vec3(coordinateEnd).z - vec3(coordinateBegin).z
   return vec3(x, y, z)
end

function UTC()
   local T = curTime - timeZone * 3600
   return T
end

function UTCscaner(system)
   local T = system.getArkTime() - timeZone * 3600
   return T
end

-- прибавляет к вектору, из двух координат, кусочек длины
-- и воозращает координату окончания вектора, с учетом прибалвенной длины
function vectorLengthen(coordinateBegin, coordinateEnd, deltaLen)
   local vector = makeVector(coordinateBegin, coordinateEnd)
   --длина вектора
   local lenVector = vec3(vector):len()
   -- новая длина вектора
   local newLen = lenVector + deltaLen
   local factor = newLen / lenVector
   --новый вектор с удлиненной координатой
   local newVector = vector * factor
   -- надо прибавить к первой начальной координате полученый вектор
   local x = vec3(coordinateBegin).x + vec3(newVector).x
   local y = vec3(coordinateBegin).y + vec3(newVector).y
   local z = vec3(coordinateBegin).z + vec3(newVector).z
   -- итого координата окончания удлиненного вектора
   local resultCoordinate = vec3(x, y, z)
   return resultCoordinate
end

function start(unit, system, text)
   pos1time = 0
   pos2time = 0
   tspeed = 0
   tspeed1 = 0
   mmode = true
   --lalt = false

   --system.createWidgetPanel("Target Vector")
   deg2rad = math.pi / 180
   rad2deg = 180 / math.pi
   ms2kmh = 3600 / 1000
   kmh2ms = 1000 / 3600

   showMarker = true

   if GHUD_export_mode == true then
      system.print("---------------")
      system.print("The export mode is enabled ALT+G")
   else
      system.print("---------------")
      system.print("The export mode is disabled ALT+G")
   end

   SU = 10
   calcTargetSpeed = targetSpeed / 3.6
   meterMarker = 0

   if
   databank_1.getStringValue(1) ~= "" and databank_1.getFloatValue(2) ~= 0 and databank_1.getStringValue(3) ~= "" and
   databank_1.getFloatValue(4) ~= 0
   then
      system.print("Coordinates from DB are used!")

      pos1 = databank_1.getStringValue(1)
      pos2 = databank_1.getStringValue(3)
      pos1time = databank_1.getFloatValue(2)
      pos2time = databank_1.getFloatValue(4)

      pos11 = zeroConvertToWorldCoordinates(pos1, system)

      pos22 = zeroConvertToWorldCoordinates(pos2, system)

      Pos1 = pos1
      Pos2 = pos2

      privMySignAngleR = 0
      privMySignAngleUp = 0
      privTargetSignAngleR = 0
      privTargetSignAngleUp = 0
      targetVector = vec3.new(0, 0, 0)
      myAngleR = 0
      myAngleUp = 0
      targetAngleR = 0
      targetAngleUp = 0

      targetVector =
      makeVector(zeroConvertToWorldCoordinates(Pos1, system), zeroConvertToWorldCoordinates(Pos2, system))
      targetTracker = true

      curTime = system.getUtcTime()

      --local dt1 = math.floor(UTC() - pos1time)
      --local dt2 = math.floor(UTC() - pos2time)
      local lasttime = math.floor(curTime - pos2time)
      local dist1 = pos11:dist(pos22)
      local timeroute = pos2time - pos1time
      tspeed = dist1 / timeroute
      tspeed1 = math.floor((dist1 / timeroute) * 3.6)
      meterMarker1 = (lasttime * tspeed) + tspeed * 4

      --length = SU*200000
      length1 = meterMarker1
      --lengthSU1=math.floor((length1/200000) * 100)/100
      lengthSU1 = string.format("%0.2f", ((length1 / 200000) * 100) / 100)

      meterMarker = (lasttime * calcTargetSpeed) + calcTargetSpeed * 4

      --length = SU*200000
      length = meterMarker
      --lengthSU=math.floor((length/200000) * 100)/100
      lengthSU = string.format("%0.2f", ((length / 200000) * 100) / 100)

      resultVector1 = vectorLengthen(pos11, pos22, length1)
      Waypoint1 = getPos4Vector(resultVector1)

      system.setWaypoint(Waypoint1)

      system.print("The target flew 20 km " .. lengthSU1 .. " su, speed " .. tspeed1 .. " km/h")

      unit.setTimer("marker", 1)
      --system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
   else
      databank_1.clear()
      blockTime = 0
      databank_1.setFloatValue(2, blockTime)
      databank_1.setFloatValue(4, blockTime)
      pos1 = 0
      pos2 = 0
      lasttime = 0
      pos1time = 0
      pos2time = 0
      meterMarker = 0
      meterMarker1 = 0

      Pos1 = 0
      Pos2 = 0
      privMySignAngleR = 0
      privMySignAngleUp = 0
      privTargetSignAngleR = 0
      privTargetSignAngleUp = 0
      targetVector = vec3.new(0, 0, 0)
      targetTracker = false
      myAngleR = 0
      myAngleUp = 0
      targetAngleR = 0
      targetAngleUp = 0

      system.print("Coordinates are missing set new or export")
   end
end

function inTEXT(unit, system, text)
   if pos1 ~= 0 and string.find(text, "::pos") and pos2 == 0 and GHUD_export_mode == false then
      --local lasttime = UTCscaner()

      pos2 = text
      databank_1.setStringValue(3, pos2)
      pos2time = math.floor(system.getUtcTime())
      databank_1.setFloatValue(4, pos2time)
      system.print(text .. " pos2 saved")

      pos11 = zeroConvertToWorldCoordinates(pos1, system)

      pos22 = zeroConvertToWorldCoordinates(pos2, system)

      local dist1 = pos11:dist(pos22)
      local timeroute = pos2time - pos1time
      tspeed = dist1 / timeroute
      tspeed1 = math.floor((dist1 / timeroute) * 3.6)
      Pos1 = pos1
      Pos2 = pos2

      targetVector =
      makeVector(zeroConvertToWorldCoordinates(Pos1, system), zeroConvertToWorldCoordinates(Pos2, system))
      targetTracker = true

      --length = SU*200000
      --meterMarker = meterMarker + 33333.32
      --meterMarker = meterMarker + calcTargetSpeed*4
      meterMarker1 = meterMarker1 + tspeed * 4
      length1 = meterMarker1

      resultVector1 = vectorLengthen(pos11, pos22, length1)
      Waypoint1 = getPos4Vector(resultVector1)

      system.setWaypoint(Waypoint1)
      meterMarker = meterMarker + calcTargetSpeed * 4
      length = meterMarker

      resultVector = vectorLengthen(pos11, pos22, length)
      Waypoint = getPos4Vector(resultVector)

      --system.setWaypoint(Waypoint)

      system.print("---------------")
      system.print("The coordinates are set manually!")
      posExport1 = databank_1.getStringValue(1)
      posExport2 = databank_1.getStringValue(3)
      timeExport1 = math.floor(databank_1.getFloatValue(2))
      timeExport2 = math.floor(databank_1.getFloatValue(4))

      system.print("The coordinates were exported to the screen")

      screen_1.setHTML(posExport1 .. "/" .. timeExport1 .. "/" .. posExport2 .. "/" .. timeExport2)
      system.print("Target speed: " .. tspeed1 .. " km/h")
      unit.setTimer("marker", 1)
      --system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
   end

   if pos1 == 0 and string.find(text, "::pos") and GHUD_export_mode == false then
      pos1 = text
      databank_1.setStringValue(1, pos1)
      pos1time = math.floor(system.getUtcTime())
      databank_1.setFloatValue(2, pos1time)
      system.print(text .. " pos1 saved")
   end

   if text == "n" then
      unit.stopTimer("marker")
      databank_1.clear()
      showMarker = true
      blockTime = 0
      databank_1.setFloatValue(2, blockTime)
      databank_1.setFloatValue(4, blockTime)
      pos1 = 0
      pos2 = 0
      lasttime = 0
      pos1time = 0
      pos2time = 0
      meterMarker = 0
      meterMarker1 = 0
      SU = 10

      --system.showScreen(0)
      unit.stopTimer("vectorhud")
      vectorHUD = ''
      Pos1 = 0
      Pos2 = 0
      privMySignAngleR = 0
      privMySignAngleUp = 0
      privTargetSignAngleR = 0
      privTargetSignAngleUp = 0
      targetVector = vec3.new(0, 0, 0)
      targetTracker = false
      myAngleR = 0
      myAngleUp = 0
      targetAngleR = 0
      targetAngleUp = 0

      system.print("---------------")
      system.print("Coordinates have been deleted, set new coordinates")
   end

   if GHUD_export_mode == true and string.find(text, "/") and not string.find(text, "/::pos") then
      unit.stopTimer("marker")
      databank_1.clear()
      showMarker = true
      blockTime = 0
      databank_1.setFloatValue(2, blockTime)
      databank_1.setFloatValue(4, blockTime)
      pos1 = 0
      pos2 = 0
      lasttime = 0
      pos1time = 0
      pos2time = 0
      meterMarker = 0
      meterMarker1 = 0
      SU = 10

      --system.showScreen(0)
      unit.stopTimer("vectorhud")
      vectorHUD = ''
      Pos1 = 0
      Pos2 = 0
      privMySignAngleR = 0
      privMySignAngleUp = 0
      privTargetSignAngleR = 0
      privTargetSignAngleUp = 0
      targetVector = vec3.new(0, 0, 0)
      targetTracker = false
      myAngleR = 0
      myAngleUp = 0
      targetAngleR = 0
      targetAngleUp = 0

      local start = 0
      local fin = string.find(text, "/", start) - 1
      pos1 = string.sub(text, start, fin)
      system.print(pos1)

      start = fin + 2
      fin = string.find(text, "/", start) - 1
      pos1time = tonumber(string.sub(text, start, fin))
      system.print(pos1time)

      start = fin + 2
      fin = string.find(text, "/", start) - 1
      pos2 = string.sub(text, start, fin)
      system.print(pos2)

      start = fin + 2
      fin = string.find(text, "/", start)
      pos2time = tonumber(string.sub(text, start, fin))
      system.print(pos2time)

      system.print("---------------")
      --system.print(pos1.."/"..pos2.."/"..oldTime)
      system.print("The coordinates have been loaded successfully!")
      databank_1.setStringValue(1, pos1)
      databank_1.setFloatValue(2, pos1time)
      databank_1.setStringValue(3, pos2)
      databank_1.setFloatValue(4, pos2time)

      pos11 = zeroConvertToWorldCoordinates(pos1, system)

      pos22 = zeroConvertToWorldCoordinates(pos2, system)

      Pos1 = pos1
      Pos2 = pos2

      targetVector =
      makeVector(zeroConvertToWorldCoordinates(Pos1, system), zeroConvertToWorldCoordinates(Pos2, system))
      targetTracker = true

      oldTime = tonumber(string.sub(text, start, fin))
      curTime = system.getUtcTime()

      --local dt1 = math.floor(UTC() - pos1time)
      --local dt2 = math.floor(UTC() - pos2time)
      local lasttime = math.floor(curTime - pos2time)
      local dist1 = pos11:dist(pos22)
      local timeroute = pos2time - pos1time
      tspeed = dist1 / timeroute
      tspeed1 = math.floor((dist1 / timeroute) * 3.6)
      meterMarker1 = (lasttime * tspeed) + tspeed * 4

      --length = SU*200000
      length1 = meterMarker1
      --lengthSU1=math.floor((length1/200000) * 100)/100
      lengthSU1 = string.format("%0.2f", ((length1 / 200000) * 100) / 100)

      meterMarker = (lasttime * calcTargetSpeed) + calcTargetSpeed * 4

      --length = SU*200000
      length = meterMarker
      --lengthSU=math.floor((length/200000) * 100)/100
      lengthSU = string.format("%0.2f", ((length / 200000) * 100) / 100)

      resultVector1 = vectorLengthen(pos11, pos22, length1)
      Waypoint1 = getPos4Vector(resultVector1)

      system.setWaypoint(Waypoint1)

      system.print("The target flew " .. lengthSU1 .. " su, speed " .. tspeed1 .. " km/h")

      system.setWaypoint(Waypoint1)
      unit.setTimer("marker", 1)
      --system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
   end
   if GHUD_export_mode == true and string.find(text, "/::pos") then
      unit.stopTimer("marker")
      databank_1.clear()
      showMarker = true
      blockTime = 0
      databank_1.setFloatValue(2, blockTime)
      databank_1.setFloatValue(4, blockTime)
      pos1 = 0
      pos2 = 0
      lasttime = 0
      pos1time = 0
      pos2time = 0
      meterMarker = 0
      meterMarker1 = 0
      SU = 10

      --system.showScreen(0)
      unit.stopTimer("vectorhud")
      vectorHUD = ''
      Pos1 = 0
      Pos2 = 0
      privMySignAngleR = 0
      privMySignAngleUp = 0
      privTargetSignAngleR = 0
      privTargetSignAngleUp = 0
      targetVector = vec3.new(0, 0, 0)
      targetTracker = false
      myAngleR = 0
      myAngleUp = 0
      targetAngleR = 0
      targetAngleUp = 0

      local start = 0
      local fin = string.find(text, "/", start) - 1
      pos1 = string.sub(text, start, fin)
      system.print(pos1)

      start = fin + 2
      fin = string.find(text, "/", start) - 1
      pos1time = tonumber(string.sub(text, start, fin))
      system.print(pos1time)

      start = fin + 2
      fin = string.find(text, "/", start) - 1
      pos2 = string.sub(text, start, fin)
      system.print(pos2)

      start = fin + 2
      fin = string.find(text, "/", start)
      pos2time = tonumber(string.sub(text, start, fin))
      system.print(pos2time)

      system.print("---------------")
      --system.print(pos1.."/"..pos2.."/"..oldTime)
      system.print("The coordinates have been loaded successfully!")
      databank_1.setStringValue(1, pos1)
      databank_1.setFloatValue(2, pos1time)
      databank_1.setStringValue(3, pos2)
      databank_1.setFloatValue(4, pos2time)

      pos11 = zeroConvertToWorldCoordinates(pos1, system)

      pos22 = zeroConvertToWorldCoordinates(pos2, system)

      Pos1 = pos1
      Pos2 = pos2

      targetVector =
      makeVector(zeroConvertToWorldCoordinates(Pos1, system), zeroConvertToWorldCoordinates(Pos2, system))
      targetTracker = true

      oldTime = tonumber(string.sub(text, start, fin))
      curTime = system.getUtcTime()

      --local dt1 = math.floor(UTC() - pos1time)
      --local dt2 = math.floor(UTC() - pos2time)
      local lasttime = math.floor(curTime - pos2time)
      local dist1 = pos11:dist(pos22)
      local timeroute = pos2time - pos1time
      tspeed = dist1 / timeroute
      tspeed1 = math.floor((dist1 / timeroute) * 3.6)
      meterMarker1 = (lasttime * tspeed) + tspeed * 4

      --length = SU*200000
      length1 = meterMarker1
      --lengthSU1=math.floor((length1/200000) * 100)/100
      lengthSU1 = string.format("%0.2f", ((length1 / 200000) * 100) / 100)

      meterMarker = (lasttime * calcTargetSpeed) + calcTargetSpeed * 4

      --length = SU*200000
      length = meterMarker
      --lengthSU=math.floor((length/200000) * 100)/100
      lengthSU = string.format("%0.2f", ((length / 200000) * 100) / 100)

      resultVector1 = vectorLengthen(pos11, pos22, length1)
      Waypoint1 = getPos4Vector(resultVector1)

      system.setWaypoint(Waypoint1)

      system.print("The target flew " .. lengthSU1 .. " su, speed " .. tspeed1 .. " km/h")

      system.setWaypoint(Waypoint1)
      unit.setTimer("marker", 1)
      --system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
   end
   if string.find(text, "mar") then
      if showMarker == true then
         showMarker = false
         system.print("Current target position - OFF")
      end
      local mar = tonumber((text):sub(4))
      if databank_1.getStringValue(1) ~= "" and databank_1.getStringValue(3) ~= "" then
         local length2 = mar * 200000

         local pos123 = databank_1.getStringValue(1)
         local pos234 = databank_1.getStringValue(3)

         pos111 = zeroConvertToWorldCoordinates(pos123, system)
         pos222 = zeroConvertToWorldCoordinates(pos234, system)

         local resultVector2 = vectorLengthen(pos111, pos222, length2)
         local Waypoint3 = getPos4Vector(resultVector2)

         system.print(Waypoint3 .. " waypoint " .. mar .. " su")
      end
   end
end

function tickVector(unit, system, text)
   if targetTracker == true and targetVector.x ~= 0 and targetVector.y ~= 0 and targetVector.z ~= 0 then
      local pipeDist = getPipeD(system)
      local worldOrintUp = vec3(construct.getWorldOrientationUp()):normalize()
      local worldOrintRight = vec3(construct.getWorldOrientationRight()):normalize()
      local worldOrintForw = vec3(construct.getWorldOrientationForward()):normalize()
      local mySpeedVectorNorm = vec3(construct.getWorldVelocity()):normalize()
      local projectedWorldUp = mySpeedVectorNorm:project_on_plane(worldOrintUp)
      local projectedWorldR = mySpeedVectorNorm:project_on_plane(worldOrintRight)
      local projectedWorldF = mySpeedVectorNorm:project_on_plane(worldOrintForw)

      local myRotateDirR = projectedWorldF:cross(worldOrintUp):normalize()
      myAngleR = projectedWorldUp:angle_between(worldOrintForw)
      local mySignAngleR = utils.sign(myRotateDirR:angle_between(worldOrintForw) - math.pi / 2)
      if mySignAngleR ~= 0 then
         myAngleR = myAngleR * mySignAngleR
         privMySignAngleR = mySignAngleR
      else
         myAngleR = myAngleR * privMySignAngleR
      end

      local myRotateDirUp = projectedWorldR:cross(worldOrintUp):normalize()
      myAngleUp = projectedWorldR:angle_between(-worldOrintUp) - math.pi / 2
      local mySignAngleUp = utils.sign(myRotateDirUp:angle_between(worldOrintRight) - math.pi / 2)
      if mySignAngleUp ~= 0 then
         myAngleUp = myAngleUp * mySignAngleUp
         privMySignAngleUp = mySignAngleUp
      else
         myAngleUp = myAngleUp * privMySignAngleUp
      end
      local targetVectorNorm = targetVector:normalize()

      local targetProjectedWorldUp = targetVectorNorm:project_on_plane(worldOrintUp)
      local targetProjectedWorldR = targetVectorNorm:project_on_plane(worldOrintRight)
      local targetProjectedWorldF = targetVectorNorm:project_on_plane(worldOrintForw)
      local targetRotateDirR = targetProjectedWorldF:cross(worldOrintUp):normalize()
      targetAngleR = targetProjectedWorldUp:angle_between(worldOrintForw)
      local targetSignAngleR = utils.sign(targetRotateDirR:angle_between(worldOrintForw) - math.pi / 2)

      if targetSignAngleR ~= 0 then
         targetAngleR = targetAngleR * targetSignAngleR
         privTargetSignAngleR = targetSignAngleR
      else
         targetAngleR = targetAngleR * privTargetSignAngleR
      end
      local targetRotateDirUp = targetProjectedWorldR:cross(worldOrintUp):normalize()
      targetAngleUp = targetProjectedWorldR:angle_between(-worldOrintUp) - math.pi / 2
      local targetSignAngleUp = utils.sign(targetRotateDirUp:angle_between(worldOrintRight) - math.pi / 2)
      if targetSignAngleUp ~= 0 then
         targetAngleUp = targetAngleUp * targetSignAngleUp
         privTargetSignAngleUp = targetSignAngleUp
      else
         targetAngleUp = targetAngleUp * privTargetSignAngleUp
      end
      --system.print(targetAngleR*rad2deg.. [[ | ]].. targetAngleUp*rad2deg)
      targetVectorWidget =
      [[

      <div class='circle' style='position:absolute;top:85%;left:43%;'>
      <div style='transform: translate(0px, -16px);color:#ffb750;'>]] ..
      string.format("%0.1f", myAngleR * rad2deg) ..
      [[°</div>
      <div style='transform: translate(70px, -35px);color:#f54425;'>]] ..
      string.format("%0.1f", targetAngleR * rad2deg) ..
      [[°</div>
      <div style='transform: translate(20px, 70px);color:#f54425;'>Δ ]] ..
      string.format("%0.1f", myAngleR * rad2deg - targetAngleR * rad2deg) ..
      [[°</div>
      </div>
      <div class='vectorLine' style='top:89.65%;left:43%;background:#ffb750;z-index:30;transform:rotate(]] ..
      myAngleR * rad2deg + 90 ..
      [[deg)'></div>


      <div class='circle' style='position:absolute;top:85%;left:51%;'>
      <div style='transform: translate(0px, -16px);color:#ffb750;'>]] ..
      string.format("%0.1f", myAngleUp * rad2deg) ..
      [[°</div>
      <div style='transform: translate(70px, -35px);color:#f54425;'>]] ..
      string.format("%0.1f", targetAngleUp * rad2deg) ..
      [[°</div>
      <div style='transform: translate(20px, 70px);color:#f54425;'>Δ ]] ..
      string.format(
      "%0.1f",
      myAngleUp * rad2deg - targetAngleUp * rad2deg
      ) ..
      [[°</div>
      </div>
      <div class='vectorLine' style='top:89.65%;left:51%;background:#ffb750;z-index:30;transform:rotate(]] ..
      myAngleUp * rad2deg + 180 ..
      [[deg)'></div>


      <div class='vectorLine' style='top:89.65%;left:43%;background:#f54425;z-index:29;transform:rotate(]] ..
      targetAngleR * rad2deg + 90 ..
      [[deg)'></div>
      <div class='vectorLine' style='top:89.65%;left:51%;background:#f54425;z-index:29;transform:rotate(]] ..
      targetAngleUp * rad2deg + 180 ..
      [[deg)'></div>
      ]]

      html1 =
      [[
      <style>
      .main1 {
         position: fixed;
         width: auto;
         padding: 0.2vw;
         bottom: 3vh;
         left: 49.7%;
         transform: translateX(-50%);
         text-align: center;
         background: #142027;
         color: white;
         font-family: verdana;
         font-size: 1em;
         border-radius: 2vh;
         border: 0.2vh solid;
         border-color: #fca503;
         </style>
         <div class="main1">]] ..
         pipeDist .. [[</div>]]

         style =
         [[
         <style>
         .circle {
            height: 100px;
            width: 100px;
            background-color: #555;
            border-radius: 50%;
            opacity: 0.5
         }     .vectorLine{position:absolute;transform-origin: 100% 0%;width: 50px;height:0.15em;}</style>]]
         --system.setScreen([[<html><head>]] .. style .. [[</head><body>]] .. targetVectorWidget .. [[]] .. html1 .. [[</body></html>]])
         vectorHUD = [[<html><head>]] .. style .. [[</head><body>]] .. targetVectorWidget .. [[]] .. html1 .. [[</body></html>]]
      end
   end

   function tickMarker(unit, system, text)
      if databank_1.getStringValue(1) ~= "" or databank_1.getStringValue(3) ~= "" and databank_1.getFloatValue(2) == 0 or databank_1.getFloatValue(4) == 0 then

         pos11 = zeroConvertToWorldCoordinates(pos1, system)
         pos22 = zeroConvertToWorldCoordinates(pos2, system)

         meterMarker1 = meterMarker1 + tspeed
         length1 = meterMarker1
         --lengthSU1=math.floor((length1/200000) * 100)/100
         lengthSU1 = string.format("%0.2f", ((length1 / 200000) * 100) / 100)
         resultVector1 = vectorLengthen(pos11, pos22, length1)
         Waypoint1 = getPos4Vector(resultVector1)

         meterMarker = meterMarker + calcTargetSpeed
         length = meterMarker
         --lengthSU=math.floor((length/200000) * 100)/100
         lengthSU = string.format("%0.2f", ((length / 200000) * 100) / 100)
         resultVector = vectorLengthen(pos11, pos22, length)
         Waypoint = getPos4Vector(resultVector)

         if showMarker == true then
            if mmode == true then
               system.setWaypoint(Waypoint1)
               system.print("The target flew " .. lengthSU1 .. " su, speed " .. tspeed1 .. " km/h")
            else
               system.setWaypoint(Waypoint)
               system.print("The target flew " .. lengthSU .. " su, speed " .. targetSpeed .. " km/h")
            end
         end
      end
   end

   function altUP(unit, system, text)
      --if lalt == true then
         if databank_1.getStringValue(1) ~= "" and databank_1.getStringValue(3) ~= "" then
            showMarker = false
            SU = SU + 2.5
            length = SU * 200000

            pos11 = zeroConvertToWorldCoordinates(pos1, system)
            pos22 = zeroConvertToWorldCoordinates(pos2, system)

            resultVector = vectorLengthen(pos11, pos22, length)
            Waypoint = getPos4Vector(resultVector)

            system.setWaypoint(Waypoint)

            system.print(Waypoint .. " waypoint " .. SU .. " su")
         end
      --end
   end

   function altDOWN(unit, system, text)
      --if lalt == true then
         if databank_1.getStringValue(1) ~= "" and databank_1.getStringValue(3) ~= "" then
            showMarker = false
            SU = SU - 2.5
            length = SU * 200000

            pos11 = zeroConvertToWorldCoordinates(pos1, system)
            pos22 = zeroConvertToWorldCoordinates(pos2, system)

            resultVector = vectorLengthen(pos11, pos22, length)
            Waypoint = getPos4Vector(resultVector)

            system.setWaypoint(Waypoint)

            system.print(Waypoint .. " waypoint " .. SU .. " su")
         end
      --end
   end

   function altRIGHT(unit, system, text)
      --if lalt == true then
         if databank_1.getStringValue(1) ~= "" and databank_1.getStringValue(3) ~= "" then
            showMarker = false
            SU = SU + 10
            length = SU * 200000

            pos11 = zeroConvertToWorldCoordinates(pos1, system)
            pos22 = zeroConvertToWorldCoordinates(pos2, system)

            resultVector = vectorLengthen(pos11, pos22, length)
            Waypoint = getPos4Vector(resultVector)

            system.setWaypoint(Waypoint)

            system.print(Waypoint .. " waypoint " .. SU .. " su")
         end
      --end
   end

   function altLEFT(unit, system, text)
      --if lalt == true then
         if databank_1.getStringValue(1) ~= "" and databank_1.getStringValue(3) ~= "" then
            showMarker = false
            SU = SU - 10
            length = SU * 200000

            pos11 = zeroConvertToWorldCoordinates(pos1, system)
            pos22 = zeroConvertToWorldCoordinates(pos2, system)

            resultVector = vectorLengthen(pos11, pos22, length)
            Waypoint = getPos4Vector(resultVector)

            system.setWaypoint(Waypoint)

            system.print(Waypoint .. " waypoint " .. SU .. " su")
         end
      --end
   end

   function GEAR(unit, system, text)
      posExport1 = databank_1.getStringValue(1)
      posExport2 = databank_1.getStringValue(3)
      --timeExport1 = tonumber(string.format('%0.0f',databank_1.getFloatValue(2)))
      --timeExport2 = tonumber(string.format('%0.0f',databank_1.getFloatValue(2)))
      timeExport1 = math.floor(databank_1.getFloatValue(2))
      timeExport2 = math.floor(databank_1.getFloatValue(4))

      system.print("The coordinates were exported to the screen")

      screen_1.setHTML(posExport1 .. "/" .. timeExport1 .. "/" .. posExport2 .. "/" .. timeExport2)
      --system.logInfo('testLua: ```'..posExport1..'/'..posExport2..'/'..timeExport..'```')
      --screen_1.activate()
   end

   function radarPos(system,radar)
      local id = radar_1.getTargetId()
      if id ~= 0 then
         local dist = radar_1.getConstructDistance(id)
         local forwvector = vec3(system.getCameraWorldForward())
         local worldpos = vec3(system.getCameraWorldPos())
         local p = (dist * forwvector + worldpos)

         if pos1 ~= 0 and pos2 == 0 and GHUD_export_mode == false then

            pos2 = '::pos{0,0,'..p.x..','..p.y..','..p.z..'}'
            databank_1.setStringValue(3, pos2)
            pos2time = math.floor(system.getUtcTime())
            databank_1.setFloatValue(4, pos2time)
            system.print(pos2 .." pos2 saved")

            pos11 = zeroConvertToWorldCoordinates(pos1, system)

            pos22 = zeroConvertToWorldCoordinates(pos2, system)

            local dist1 = pos11:dist(pos22)
            local timeroute = pos2time - pos1time
            tspeed = dist1 / timeroute
            tspeed1 = math.floor((dist1 / timeroute) * 3.6)
            Pos1 = pos1
            Pos2 = pos2

            targetVector =
            makeVector(zeroConvertToWorldCoordinates(Pos1, system), zeroConvertToWorldCoordinates(Pos2, system))
            targetTracker = true

            meterMarker1 = meterMarker1 + tspeed * 4
            length1 = meterMarker1

            resultVector1 = vectorLengthen(pos11, pos22, 6000000)
            Waypoint1 = getPos4Vector(resultVector1)

            system.setWaypoint(Waypoint1)
            meterMarker = meterMarker + calcTargetSpeed * 4
            length = meterMarker

            resultVector = vectorLengthen(pos11, pos22, length)
            Waypoint = getPos4Vector(resultVector)

            system.print("---------------")
            system.print("The coordinates are set manually!")
            posExport1 = databank_1.getStringValue(1)
            posExport2 = databank_1.getStringValue(3)
            timeExport1 = math.floor(databank_1.getFloatValue(2))
            timeExport2 = math.floor(databank_1.getFloatValue(4))

            system.print("The coordinates were exported to the screen")

            screen_1.setHTML(posExport1 .. "/" .. timeExport1 .. "/" .. posExport2 .. "/" .. timeExport2)
            system.print("Target speed: " .. tspeed1 .. " km/h")
            --unit.setTimer("marker", 1)
            --system.showScreen(1)
            unit.setTimer("vectorhud", 0.02)
         end

         if pos1 == 0 and GHUD_export_mode == false then
            pos1 = '::pos{0,0,'..p.x..','..p.y..','..p.z..'}'
            databank_1.setStringValue(1, pos1)
            pos1time = math.floor(system.getUtcTime())
            databank_1.setFloatValue(2, pos1time)
            system.print(pos1 .. " pos1 saved")
         end
      end
   end

   start(unit,system,text)

   local preloader = [[
   <html>
   <style>
   .imgLogo {
      position: relative;
      margin-top: 8vh;
      height: 400px;
      margin-left: auto;
      margin-right: auto;
      text-align: center;
      background-image: url("assets.prod.novaquark.com/3014/36dec597-dbf2-46a4-95c7-8e135dd77889.png");
      background-size: 400px;
      background-repeat: no-repeat;
      background-position: center center;
      transition: background 800ms ease-in 800ms;
   }

   .text {
      top: 0;
      left: 0;
      width: fit-content;
      position: relative;
      margin-left: auto;
      margin-right: auto;
      text-align: center;
      font-size: 40px;
      font-family: Arial, Helvetica, sans-serif;
      font-weight: bold;
      color: white;
      transition: background 800ms ease-in 800ms;
   }

   .fade-in {
      animation: fadeIn ease 3s;
      -webkit-animation: fadeIn ease 3s;
      -moz-animation: fadeIn ease 3s;
      -o-animation: fadeIn ease 3s;
      -ms-animation: fadeIn ease 3s;
   }

   @keyframes fadeIn {
      0% {
         opacity: 0;
      }

      100% {
         opacity: 1;
      }
   }

   @-moz-keyframes fadeIn {
      0% {
         opacity: 0;
      }

      100% {
         opacity: 1;
      }
   }

   @-webkit-keyframes fadeIn {
      0% {
         opacity: 0;
      }

      100% {
         opacity: 1;
      }
   }

   @-o-keyframes fadeIn {
      0% {
         opacity: 0;
      }

      100% {
         opacity: 1;
      }
   }

   @-ms-keyframes fadeIn {
      0% {
         opacity: 0;
      }

      100% {
         opacity: 1;
      }
   }

   .spinner {
      top: 30px;
      width: 70px;
      text-align: center;
      position: relative;
      margin-left: auto;
      margin-right: auto;
      margin-top: 0;
   }

   .spinner>div {
      width: 18px;
      height: 18px;
      background-color: #14dbcb;
      border-radius: 100%;
      display: inline-block;
      -webkit-animation: sk-bouncedelay 1.4s infinite ease-in-out both;
      animation: sk-bouncedelay 1.4s infinite ease-in-out both;
   }

   .spinner .bounce1 {
      -webkit-animation-delay: -0.32s;
      animation-delay: -0.32s;
   }

   .spinner .bounce2 {
      -webkit-animation-delay: -0.16s;
      animation-delay: -0.16s;
   }

   @-webkit-keyframes sk-bouncedelay {

      0%,
      80%,
      100% {
         -webkit-transform: scale(0)
      }

      40% {
         -webkit-transform: scale(1.0)
      }
   }

   @keyframes sk-bouncedelay {

      0%,
      80%,
      100% {
         -webkit-transform: scale(0);
         transform: scale(0);
      }

      40% {
         -webkit-transform: scale(1.0);
         transform: scale(1.0);
      }
   }
   </style>
   <body>
   <div class="imgLogo fade-in"></div>
   <div class="text fade-in">GEMINI FOUNDATION</div>
   <div class="spinner">
   <div class="bounce1"></div>
   <div class="bounce2"></div>
   <div class="bounce3"></div>
   </div>
   </body>
   </html>
   ]]
   system.setScreen(preloader)
   unit.setTimer("delay", 1)

   --clean performance
   if collectgarbages == true then
      unit.setTimer("cleaner",30)
   end