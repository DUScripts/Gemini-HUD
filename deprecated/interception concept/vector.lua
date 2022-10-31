function zeroConvertToWorldCoordinates(pos, system) -- Many thanks to SilverZero for this.
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
  if db.getStringValue(1) ~= "" and db.getStringValue(3) ~= "" then
      local distanceS = ""

      local length1 = -700 * 200000
      local length2 = 800 * 200000

      --local pos123 = decode(db.getStringValue(1))
      --local pos234 = decode(db.getStringValue(3))

      local pos123 = pos1
      local pos234 = pos2

      local pos111 = zeroConvertToWorldCoordinates(pos123, system)
      local pos222 = zeroConvertToWorldCoordinates(pos234, system)

      local DestinationCenter = vectorLengthen(pos111, pos222, length1)
      local DepartureCenter = vectorLengthen(pos111, pos222, length2)

      local worldPos = vec3(core.getConstructWorldPos())
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
  if db.getStringValue(1) ~= "" and db.getStringValue(3) ~= "" then
      showMarker = false

      local length1 = -700 * 200000
      local length2 = 800 * 200000

      --local pos123 = decode(db.getStringValue(1))
      --local pos234 = decode(db.getStringValue(3))

      local pos123 = pos1
      local pos234 = pos2

      local pos111 = zeroConvertToWorldCoordinates(pos123, system)
      local pos222 = zeroConvertToWorldCoordinates(pos234, system)

      local DestinationCenter = vectorLengthen(pos111, pos222, length1)
      local DepartureCenter = vectorLengthen(pos111, pos222, length2)

      local worldPos = vec3(core.getConstructWorldPos())
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
  local T = system.getTime() - timeZone * 3600
  return T
end

-- 2 keys for encription
Key53 = 8730298826345614
Key14 = 8927

local inv256

function encode(str)
  if not inv256 then
      inv256 = {}
      for M = 0, 127 do
          local inv = -1
          repeat
              inv = inv + 2
          until inv * (2 * M + 1) % 256 == 1
          inv256[M] = inv
      end
  end
  local K, F = Key53, 16384 + Key14
  return (str:gsub(
      ".",
      function(m)
          local L = K % 274877906944 -- 2^38
          local H = (K - L) / 274877906944
          local M = H % 128
          m = m:byte()
          local c = (m * inv256[M] - (H - M) / 128) % 256
          K = L * F + H + c + m
          return ("%02x"):format(c)
      end
  ))
end

function decode(str)
  local K, F = Key53, 16384 + Key14
  return (str:gsub(
      "%x%x",
      function(c)
          local L = K % 274877906944 -- 2^38
          local H = (K - L) / 274877906944
          local M = H % 128
          c = tonumber(c, 16)
          local m = (c + (H - M) / 128) * (2 * M + 1) % 256
          K = L * F + H + c + m
          return string.char(m)
      end
  ))
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
  for slot_name, slot in pairs(unit) do
      if type(slot) == "table" and type(slot.export) == "table" and slot.getElementClass then
          if slot.getElementClass():lower():find("core") then
              core = slot
          end
          if slot.getElementClass():lower():find("databank") then
              db = slot
          end
          if slot.getElementClass():lower():find("screen") then
              screen = slot
          end
      end
  end
  unit.hide()
  pos1time = 0
  pos2time = 0
  tspeed = 0
  tspeed1 = 0
  mmode = true
  lalt = false

  system.createWidgetPanel("Target Vector")
  deg2rad = math.pi / 180
  rad2deg = 180 / math.pi
  ms2kmh = 3600 / 1000
  kmh2ms = 1000 / 3600

  showMarker = true

  if exportMode == true then
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
      db.getStringValue(1) ~= "" and db.getFloatValue(2) ~= 0 and db.getStringValue(3) ~= "" and
          db.getFloatValue(4) ~= 0
   then
      system.print("Coordinates from DB are used!")

      pos1 = decode(db.getStringValue(1))
      pos2 = decode(db.getStringValue(3))
      pos1time = db.getFloatValue(2)
      pos2time = db.getFloatValue(4)

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

      curTime = system.getTime()

      --local dt1 = math.floor(UTC() - pos1time)
      local dt2 = math.floor(UTC() - pos2time)
      local lasttime = dt2
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
      system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
  else
      db.clear()
      blockTime = 0
      db.setFloatValue(2, blockTime)
      db.setFloatValue(4, blockTime)
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
  if pos1 ~= 0 and string.find(text, "::pos") and pos2 == 0 and exportMode == false then
      --local lasttime = UTCscaner()

      pos2 = text
      db.setStringValue(3, encode(pos2))
      pos2time = math.floor(UTCscaner(system))
      db.setFloatValue(4, pos2time)
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
      posExport1 = db.getStringValue(1)
      posExport2 = db.getStringValue(3)
      timeExport1 = math.floor(db.getFloatValue(2))
      timeExport2 = math.floor(db.getFloatValue(4))

      system.print("The coordinates were exported to the screen")

      screen.setHTML(posExport1 .. "/" .. timeExport1 .. "/" .. posExport2 .. "/" .. timeExport2)
      system.print("Target speed: " .. tspeed1 .. " km/h")
      unit.setTimer("marker", 1)
      system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
  end

  if pos1 == 0 and string.find(text, "::pos") and exportMode == false then
      pos1 = text
      db.setStringValue(1, encode(pos1))
      pos1time = math.floor(UTCscaner(system))
      db.setFloatValue(2, pos1time)
      system.print(text .. " pos1 saved")
  end

  if text == "n" then
      unit.stopTimer("marker")
      db.clear()
      showMarker = true
      blockTime = 0
      db.setFloatValue(2, blockTime)
      db.setFloatValue(4, blockTime)
      pos1 = 0
      pos2 = 0
      lasttime = 0
      pos1time = 0
      pos2time = 0
      meterMarker = 0
      meterMarker1 = 0
      SU = 10

      system.showScreen(0)
      unit.stopTimer("vectorhud")
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

  if exportMode == true and string.find(text, "/") and not string.find(text, "/::pos") then
      unit.stopTimer("marker")
      db.clear()
      showMarker = true
      blockTime = 0
      db.setFloatValue(2, blockTime)
      db.setFloatValue(4, blockTime)
      pos1 = 0
      pos2 = 0
      lasttime = 0
      pos1time = 0
      pos2time = 0
      meterMarker = 0
      meterMarker1 = 0
      SU = 10

      system.showScreen(0)
      unit.stopTimer("vectorhud")
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
      pos1 = decode(pos1)
      system.print(pos1)

      start = fin + 2
      fin = string.find(text, "/", start) - 1
      pos1time = tonumber(string.sub(text, start, fin))
      system.print(pos1time)

      start = fin + 2
      fin = string.find(text, "/", start) - 1
      pos2 = string.sub(text, start, fin)
      pos2 = decode(pos2)
      system.print(pos2)

      start = fin + 2
      fin = string.find(text, "/", start)
      pos2time = tonumber(string.sub(text, start, fin))
      system.print(pos2time)

      system.print("---------------")
      --system.print(pos1.."/"..pos2.."/"..oldTime)
      system.print("The coordinates have been loaded successfully!")
      db.setStringValue(1, encode(pos1))
      db.setFloatValue(2, pos1time)
      db.setStringValue(3, encode(pos2))
      db.setFloatValue(4, pos2time)

      pos11 = zeroConvertToWorldCoordinates(pos1, system)

      pos22 = zeroConvertToWorldCoordinates(pos2, system)

      Pos1 = pos1
      Pos2 = pos2

      targetVector =
          makeVector(zeroConvertToWorldCoordinates(Pos1, system), zeroConvertToWorldCoordinates(Pos2, system))
      targetTracker = true

      oldTime = tonumber(string.sub(text, start, fin))
      curTime = system.getTime()

      --local dt1 = math.floor(UTC() - pos1time)
      local dt2 = math.floor(UTC() - pos2time)
      local lasttime = dt2
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
      system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
  end
  if exportMode == true and string.find(text, "/::pos") then
      unit.stopTimer("marker")
      db.clear()
      showMarker = true
      blockTime = 0
      db.setFloatValue(2, blockTime)
      db.setFloatValue(4, blockTime)
      pos1 = 0
      pos2 = 0
      lasttime = 0
      pos1time = 0
      pos2time = 0
      meterMarker = 0
      meterMarker1 = 0
      SU = 10

      system.showScreen(0)
      unit.stopTimer("vectorhud")
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
      db.setStringValue(1, encode(pos1))
      db.setFloatValue(2, pos1time)
      db.setStringValue(3, encode(pos2))
      db.setFloatValue(4, pos2time)

      pos11 = zeroConvertToWorldCoordinates(pos1, system)

      pos22 = zeroConvertToWorldCoordinates(pos2, system)

      Pos1 = pos1
      Pos2 = pos2

      targetVector =
          makeVector(zeroConvertToWorldCoordinates(Pos1, system), zeroConvertToWorldCoordinates(Pos2, system))
      targetTracker = true

      oldTime = tonumber(string.sub(text, start, fin))
      curTime = system.getTime()

      --local dt1 = math.floor(UTC() - pos1time)
      local dt2 = math.floor(UTC() - pos2time)
      local lasttime = dt2
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
      system.showScreen(1)
      unit.setTimer("vectorhud", 0.02)
  end
  if string.find(text, "mar") then
      if showMarker == true then
          showMarker = false
          system.print("Current target position - OFF")
      end
      local mar = tonumber((text):sub(4))
      if db.getStringValue(1) ~= "" and db.getStringValue(3) ~= "" then
          local length2 = mar * 200000

          local pos123 = decode(db.getStringValue(1))
          local pos234 = decode(db.getStringValue(3))

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
      local worldOrintUp = vec3(core.getConstructWorldOrientationUp()):normalize()
      local worldOrintRight = vec3(core.getConstructWorldOrientationRight()):normalize()
      local worldOrintForw = vec3(core.getConstructWorldOrientationForward()):normalize()
      local mySpeedVectorNorm = vec3(core.getWorldVelocity()):normalize()
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
          font-family: "Lucida" Grande, sans-serif;
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
      system.setScreen(
          [[<html><head>]] .. style .. [[</head><body>]] .. targetVectorWidget .. [[]] .. html1 .. [[</body></html>]]
      )
  end
end

function tickMarker(unit, system, text)
  if db.getStringValue(1) ~= "" or db.getStringValue(3) ~= "" and db.getFloatValue(2) == 0 or db.getFloatValue(4) == 0 then
      --pos1 = decode(db.getStringValue(1))
      --pos2 = decode(db.getStringValue(3))

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
  if lalt == true then
      if db.getStringValue(1) ~= "" and db.getStringValue(3) ~= "" then
          showMarker = false
          SU = SU + 2.5
          length = SU * 200000

          --pos1 = decode(db.getStringValue(1))
          --pos2 = decode(db.getStringValue(3))

          pos11 = zeroConvertToWorldCoordinates(pos1, system)
          pos22 = zeroConvertToWorldCoordinates(pos2, system)

          resultVector = vectorLengthen(pos11, pos22, length)
          Waypoint = getPos4Vector(resultVector)

          system.setWaypoint(Waypoint)

          system.print(Waypoint .. " waypoint " .. SU .. " su")
      end
  end
end

function altDOWN(unit, system, text)
  if lalt == true then
      if db.getStringValue(1) ~= "" and db.getStringValue(3) ~= "" then
          showMarker = false
          SU = SU - 2.5
          length = SU * 200000

          --pos1 = decode(db.getStringValue(1))
          --pos2 = decode(db.getStringValue(3))

          pos11 = zeroConvertToWorldCoordinates(pos1, system)
          pos22 = zeroConvertToWorldCoordinates(pos2, system)

          resultVector = vectorLengthen(pos11, pos22, length)
          Waypoint = getPos4Vector(resultVector)

          system.setWaypoint(Waypoint)

          system.print(Waypoint .. " waypoint " .. SU .. " su")
      end
  end
end

function altRIGHT(unit, system, text)
  if lalt == true then
      if db.getStringValue(1) ~= "" and db.getStringValue(3) ~= "" then
          showMarker = false
          SU = SU + 10
          length = SU * 200000

          --pos1 = decode(db.getStringValue(1))
          --pos2 = decode(db.getStringValue(3))

          pos11 = zeroConvertToWorldCoordinates(pos1, system)
          pos22 = zeroConvertToWorldCoordinates(pos2, system)

          resultVector = vectorLengthen(pos11, pos22, length)
          Waypoint = getPos4Vector(resultVector)

          system.setWaypoint(Waypoint)

          system.print(Waypoint .. " waypoint " .. SU .. " su")
      end
  end
end

function altLEFT(unit, system, text)
  if lalt == true then
      if db.getStringValue(1) ~= "" and db.getStringValue(3) ~= "" then
          showMarker = false
          SU = SU - 10
          length = SU * 200000

          --pos1 = decode(db.getStringValue(1))
          --pos2 = decode(db.getStringValue(3))

          pos11 = zeroConvertToWorldCoordinates(pos1, system)
          pos22 = zeroConvertToWorldCoordinates(pos2, system)

          resultVector = vectorLengthen(pos11, pos22, length)
          Waypoint = getPos4Vector(resultVector)

          system.setWaypoint(Waypoint)

          system.print(Waypoint .. " waypoint " .. SU .. " su")
      end
  end
end

function GEAR(unit, system, text)
  posExport1 = db.getStringValue(1)
  posExport2 = db.getStringValue(3)
  --timeExport1 = tonumber(string.format('%0.0f',db.getFloatValue(2)))
  --timeExport2 = tonumber(string.format('%0.0f',db.getFloatValue(2)))
  timeExport1 = math.floor(db.getFloatValue(2))
  timeExport2 = math.floor(db.getFloatValue(4))

  system.print("The coordinates were exported to the screen")

  screen.setHTML(posExport1 .. "/" .. timeExport1 .. "/" .. posExport2 .. "/" .. timeExport2)
  --system.logInfo('testLua: ```'..posExport1..'/'..posExport2..'/'..timeExport..'```')
  --screen.activate()
end
