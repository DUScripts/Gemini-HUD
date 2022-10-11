function checkWhitelist()
    local whitelist = friendly_IDs
    local set = {}
    for _, l in ipairs(whitelist) do set[l] = true end
    return set
 end

 --radar widget
 function defaultRadar()
   sizeState = 6
   defaultSize = 'ALL'
   if mRadar.friendlyMode == true then mRadar.friendlyMode = false end
 end

 function mRadar:createWidget()
    self.dataID = self.system.createData(self.radar.getData())
    radarPanel = self.system.createWidgetPanel('')
    radarWidget = self.system.createWidget(radarPanel, self.radar.getWidgetType())
    self.system.addDataToWidget(self.dataID, radarWidget)
 end
 
 function mRadar:createWidgetNew()
    self.dataID = self.system.createData(self.radar.getData())
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
    local sizestr = defaultSize
    local resultList = {}
    local data = mRadar.radar.getData()
    local constructList = data:gmatch('({"constructId":".-%b{}.-})')
    local isIDFiltered = next(self.idFilter) ~= nil
    local i = 0
    for str in constructList do
       i = i + 1
       if i%pauseAfter==0 then
          coroutine.yield()
       end
       local ID = tonumber(str:match('"constructId":"([%d]*)"'))
       local size = radar.getConstructCoreSize(ID)
       local locked = radar.isConstructIdentified(ID)
       local alive = radar.isConstructAbandoned(ID)
       if locked == 1 or alive == 0 then --show only locked or alive targets
         if defaultSize == 'ALL' then --default mode
         if (self.friendList[ID]==true or self.radar.hasMatchingTransponder(ID)==1) ~= self.friendlyMode then
            goto continue1
         end
         if isIDFiltered and self.idFilter[ID%1000] ~= true then
            goto continue1
         end
            resultList[#resultList+1] = str:gsub('"name":"(.+)"', '"name":"' .. string.format("%03d", ID%1000) .. ' - %1"')
            ::continue1::
         end
        if defaultSize ~= 'ALL' and size == defaultSize then --sorted
           if (self.friendList[ID]==true or self.radar.hasMatchingTransponder(ID)==1) ~= self.friendlyMode then
              goto continue2
           end
           if isIDFiltered and self.idFilter[ID%1000] ~= true then
              goto continue2
           end
              resultList[#resultList+1] = str:gsub('"name":"(.+)"', '"name":"' .. string.format("%03d", ID%1000) .. ' - %1"')
              ::continue2::
         end
      end
    end
    local filterMsg = (isIDFiltered and ''..focus..' - FOCUS - ' or '') .. (self.friendlyMode and ''..sizestr..' - Friends' or ''..sizestr..' - Enemies')
    --local postData = data:match('"elementId":".+') --deprecated
    local postData = data:match('"currentTargetId":".+')
    postData = postData:gsub('"errorMessage":""', '"errorMessage":"' .. filterMsg .. '"') --filter data
    data = '{"constructsList":[' .. table.concat(resultList, ",") .. "]," .. postData --completed global json radar data
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
 
 --function mRadar:toggleOnlyIdentified() -- locked mode
    --self.onlyIdentified = not self.onlyIdentified
 --end
 
 function mRadar:new(sys, radar, friendList)
    local mRadar = {}
    setmetatable(mRadar, self)
    self.system = sys
    self.radar = radar
    self.friendlyMode = false
    self.friendList = friendList or {}
    self.onlyIdentified = false
    self.idFilter = {}
    self:createWidget()
    self.updaterCoroutine = coroutine.create(function() self:updateLoop() end)
    return self
 end
 
 function mRadar:stopC()
    self:clearIDFilter(self.system.print("FOCUS MODE DEACTIVATED"))
 end
 ----------------------------------------------------------------------------------
 --weapon widgets
 function mWeapons:createWidgets()
    if not (type(self.weapons) == 'table' and #self.weapons > 0) then
       return
    end
    local widgetPanelID
    for i, weap in ipairs(self.weapons) do
       if (i-1) % self.weaponsPerPanel == 0 then
          widgetPanelID = self.system.createWidgetPanel('')
       end
       local weaponDataID = self.system.createData(weap.getData())
       self.weaponData[weaponDataID] = weap
       oldAnimationTime[weaponDataID] = 0
       self.system.addDataToWidget(weaponDataID, self.system.createWidget(widgetPanelID, weap.getWidgetType()))
    end
 end
 
 function mWeapons:onUpdate()
    for weaponDataID, weap in pairs(self.weaponData) do
       local weaponData = weap.getData()
       local weaponStatus = weaponData:match('"weaponStatus":(%d+)')
       local animationTime = tonumber(weaponData:match('"cycleAnimationRemainingTime":(.-),'))
       local fireReady = weaponData:match('"fireReady":(.-),')
       local outOfZone = weaponData:match('"outOfZone":(.-),')
       local targetConstructID = weaponData:match('"constructId":"(.-)"')
       local animationChanged = animationTime > oldAnimationTime[weaponDataID]
       oldAnimationTime[weaponDataID] = animationTime
 
       if weaponStatus == oldWeaponStatus[weaponDataID] and oldTargetConstruct[weaponDataID] == targetConstructID and oldFireReady[weaponDataID] == fireReady and OldoutOfZone[weaponDataID] == outOfZone and not animationChanged then
          goto continue
       end
       oldWeaponStatus[weaponDataID] = weaponStatus
       oldFireReady[weaponDataID] = fireReady
       OldoutOfZone[weaponDataID] = outOfZone
       oldTargetConstruct[weaponDataID] = targetConstructID
 
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
 
       weaponData = weaponData:gsub('"ammoName":"(.-)"', '"ammoName":"' .. ammoType2 .. ' ' .. ammoType1 .. '"')
       weaponData = weaponData:gsub('"constructId":"(%d+(%d%d%d))","name":"(.?.?.?.?).-"', '"constructId":"%1","name":"%2 - %3"')
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
 
 function GlobalVars()
    mRadar = {}
    mWeapons = {}
    size = {'XL','L','M','S','XS'}
    defaultSize = 'ALL'
    sizeState = 6
    focus = ''
    buttonSpace = false
    buttonC = false
    atmovar = alse
    newcolor = "#6affb1"
    endload = 0
    dist1 = 0
    dist3 = 0
    znak = '' --target speed icon
    firstload = 0
    firstload1 = 0
    constructSelected = 0
    probil = 0
    playerName = system.getPlayerName(unit.getMasterPlayerId())
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
    shipName = core.getConstructName()
    conID = core.getConstructId()
    system.print(''..shipName..': '..conID..'')
    conID = (""..conID..""):sub(-3)
 end
 
 --local time
 function seconds_to_clock(time_amount)
    local start_seconds = time_amount
    local start_minutes = math.modf(start_seconds/60)
    local seconds = start_seconds - start_minutes*60
    local start_hours = math.modf(start_minutes/60)
    local minutes = start_minutes - start_hours*60
    local start_days = math.modf(start_hours/24)
    local hours = start_hours - start_days*24
    local wrapped_time = {h=hours, m=minutes, s=seconds}
    return string.format('%02.f:%02.f:%02.f', wrapped_time.h, wrapped_time.m, wrapped_time.s)
 end
