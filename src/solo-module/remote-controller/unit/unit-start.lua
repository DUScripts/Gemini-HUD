-- GEMINI FOUNDATION

-- Many thanks to:
--  W1zard for weapon and radar widgets
--  tiramon for closest pipe functions
--  SeM for the help with the coroutines
--  JayleBreak for planetref functions
--  Aranol for closest pos functions and 2D planet radar
--  Mistery for vector functions
--  Middings for brake distance function
--  IvanGrozny for Echoes widget, 3D space map, icons from his "Epic HUD"
--  Chelobek for target vector widget

-- Gemini HUD is the rebirth of the CFCS HUD (Custom Fire Control System)
-- Author: GeminiX (aka SneakySnake, DU Pirate)

--Solo remote controller
HUD_version = '1.0.0'

--LUA parameters

--vars
atlas = require("atlas")
_stellarObjects = atlas[0]
safeWorldPos = vec3({13771471,7435803,-128971})

AMstrokeWidth = 1
EMstrokeWidth = 1
THstrokeWidth = 1
KIstrokeWidth = 1

--shield
damageLine = ''
ccsLineHit = ''
damage = 0
maxSHP = 210 --svg shield X right side coordinate
shieldMaxHP = shield.getMaxShieldHitpoints()
last_shield_hp = shield.getShieldHitpoints()
HP = shield.getShieldHitpoints()/shieldMaxHP * 100
svghp = maxSHP * (HP * 0.01)

--CCS
ccshit = 0
maxCCS = 139.5
coreMaxStress = core.getmaxCoreStress()
last_core_stress = core.getCoreStress()
CCS = last_core_stress/coreMaxStress * 100
ccshp1 = maxCCS * (CCS * 0.01)
ccshp = ccshp1

--FUEL
maxFUEL = maxCCS
FUEL_svg = maxFUEL * (Fuel_lvl * 0.01)

AM_last_stress = 0
EM_last_stress = 0
TH_last_stress = 0
KI_last_stress = 0
AM_svg = 0
EM_svg = 0
TH_svg = 0
KI_svg = 0
AM_stroke_color = 'rgb(66, 167, 245)'
EM_stroke_color = 'rgb(66, 167, 245)'
TH_stroke_color = 'rgb(66, 167, 245)'
KI_stroke_color = 'rgb(66, 167, 245)'

local stress = shield.getStressRatioRaw()
AM_stress = stress[1]
EM_stress = stress[2]
KI_stress = stress[3]
TH_stress = stress[4]

function damage_ccs_SVG()
   if damage > 0 then
      damage = damage - 0.1
      damageLine = [[<rect x="]].. svghp + 145 ..[[" y="225" width="]]..damage..[[" height="50" style="fill: #de1656; stroke: #de1656;" bx:origin="0.5 0.5"/>]]
   end
   if damage <= 0 then
      damage = 0
      damageLine = ''
   end

   if ccshit > 0 then
      ccshp = ccshp + 0.25
      if ccshp >= ccshp1 then
         ccshp = ccshp1
         ccsLineHit = ''
         ccshit = 0
      end
   end
end

function checkSvgStress()
   --AM
   if AM_stress ~= AM_last_stress then
      AM_last_stress = AM_stress
   end
   if AM_svg < AM_last_stress then
      AM_svg = AM_svg + 0.01
      if AM_svg >= AM_stress then AM_svg = AM_stress
   end
end
if AM_svg > AM_last_stress then
   AM_svg = AM_svg - 0.01
   if AM_svg <= AM_stress then AM_svg = AM_stress
end
end
--EM
if EM_stress ~= EM_last_stress then
EM_last_stress = EM_stress
end
if EM_svg < EM_last_stress then
EM_svg = EM_svg + 0.01
if EM_svg >= EM_stress then EM_svg = EM_stress
end
end
if EM_svg > EM_last_stress then
EM_svg = EM_svg - 0.01
if EM_svg <= EM_stress then EM_svg = EM_stress
end
end
--TH
if TH_stress ~= TH_last_stress then
TH_last_stress = TH_stress
end
if TH_svg < TH_last_stress then
TH_svg = TH_svg + 0.01
if TH_svg >= TH_stress then TH_svg = TH_stress
end
end
if TH_svg > TH_last_stress then
TH_svg = TH_svg - 0.01
if TH_svg <= TH_stress then TH_svg = TH_stress
end
end
--KI
if KI_stress ~= KI_last_stress then
KI_last_stress = KI_stress
end
if KI_svg < KI_last_stress then
KI_svg = KI_svg + 0.01
if KI_svg >= KI_stress then KI_svg = KI_stress
end
end
if KI_svg > KI_last_stress then
KI_svg = KI_svg - 0.01
if KI_svg <= KI_stress then KI_svg = KI_stress
end
end

end

function customDistance(distance)
distanceS=''
if distance < 1000 then
distanceS = ''..string.format('%0.0f', distance)..' m'
elseif distance < 100000 then
distanceS = ''..string.format('%0.1f', distance/1000)..' km'
else
distanceS = ''..string.format('%0.2f', distance/200000)..' su'
end
return distanceS
end

function getClosestPlanet(wp)
local ClosestPlanet={}
ClosestPlanet.distance=999999999999
for BodyId in pairs(atlas[0]) do
local planet=atlas[0][BodyId]
local distance=(vec3(planet.center)-wp):len()
if math.min(ClosestPlanet.distance,distance)==distance then
ClosestPlanet.name=planet.name[1]
ClosestPlanet.distance=distance
end
end
return ClosestPlanet.name,ClosestPlanet.distance
end

function getClosestPipe(wp,startLocation)
local ClosestPlanet={}
ClosestPlanet.pipedistance=999999999999
for BodyId in pairs(atlas[0]) do
local stopLocation=atlas[0][BodyId]
local pipe=vec3(startLocation.center) - vec3(stopLocation.center)
local pipedistance=(wp - vec3(startLocation.center)):project_on_plane(pipe):len()
if math.min(ClosestPlanet.pipedistance,pipedistance)==pipedistance and (vec3(startLocation.center)-wp):len()<pipe:len() and (vec3(stopLocation.center)-wp):len()<pipe:len() then
ClosestPlanet.pipename=stopLocation.name[1]
ClosestPlanet.pipedistance=pipedistance
end
end
return ClosestPlanet.pipename, ClosestPlanet.pipedistance
end

function getSafeZoneDistance(wp)
local CenterSafeZone = vec3(13771471, 7435803, -128971)
local distance=math.floor(((wp-CenterSafeZone):len()-18000000))
return distance
end

function zeroConvertToWorldCoordinates(pos,system)
local num  = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'
local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)

if systemId==nil or bodyId==nil or latitude==nil or longitude==nil or altitude==nil then
system.print("POS неверный!")
destination_bm=""
return vec3()
end

if (systemId == "0" and bodyId == "0") then
--convert space bm
return vec3(latitude,
longitude,
altitude)
end
longitude = math.rad(longitude)
latitude = math.rad(latitude)
local planet = atlas[tonumber(systemId)][tonumber(bodyId)]
local xproj = math.cos(latitude);
local planetxyz = vec3(xproj*math.cos(longitude),
xproj*math.sin(longitude),
math.sin(latitude));
return vec3(planet.center) + (planet.radius + altitude) * planetxyz
end

function zeroConvertToWorldCoordinatesG(pos,system)
local num  = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'
local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)

if systemId==nil or bodyId==nil or latitude==nil or longitude==nil or altitude==nil then
system.print("POS неверный!")
return {0, 0, 0}
end

if (systemId == "0" and bodyId == "0") then
--convert space bm
return {tonumber(latitude), tonumber(longitude), tonumber(altitude)}
end
longitude = math.rad(longitude)
latitude = math.rad(latitude)
local planet = atlas[tonumber(systemId)][tonumber(bodyId)]
local xproj = math.cos(latitude);
local planetxyz = vec3(xproj*math.cos(longitude),
xproj*math.sin(longitude),
math.sin(latitude));
return {(planet.center + (planet.radius + altitude) * planetxyz):unpack()}
end

--icons
local icons = {}
function iconStatusCheck(status)
	if status == 'on' or status == 1 then
		return 'on'
	else
		return ''
	end
end

function icons.space(status)
	return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 197.6 107.43">
		<path class="a" d="M197.19,25.35c-4.31-15-38.37-12.36-60-9.09A53.64,53.64,0,0,0,46.29,42.48C26.28,51.21-3.9,67.12.42,82.08,2.81,90.36,14.68,93.74,31.3,93.74a197.4,197.4,0,0,0,29.09-2.56A53.64,53.64,0,0,0,151.31,65C179.87,52.59,200.82,37.94,197.19,25.35Zm-98.38-16A44.44,44.44,0,0,1,143.2,53.71,45.3,45.3,0,0,1,143,58.4a363,363,0,0,1-38.9,13.51,361.77,361.77,0,0,1-40,9.27A44.32,44.32,0,0,1,98.81,9.32ZM9.37,79.5c-.83-2.89,7.34-13.18,35.74-26.27,0,.16,0,.32,0,.48a53.27,53.27,0,0,0,8.58,29C26.33,86.24,10.55,83.58,9.37,79.5ZM98.81,98.11a44.13,44.13,0,0,1-26.65-9c11.34-2.18,23.07-5,34.47-8.28s22.84-7.12,33.6-11.31A44.43,44.43,0,0,1,98.81,98.11ZM152.5,54.2c0-.16,0-.32,0-.49a53.34,53.34,0,0,0-8.56-29c31-4.05,43.45.32,44.28,3.2C189.42,32,177.43,42.64,152.5,54.2Z" />
	</svg>
	]]
end

function icons.marker(status)
	return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 148.21 197.07">
		<path class="a" d="M74.1,42.8a31.32,31.32,0,1,0,31.32,31.32A31.35,31.35,0,0,0,74.1,42.8Zm0,52A20.73,20.73,0,1,1,94.83,74.1,20.75,20.75,0,0,1,74.1,94.83Z" />
		<path class="a" d="M74.12,0A74.21,74.21,0,0,0,0,74.13c0,18.39,6.93,32.36,18.88,50.26,12.45,18.7,49.42,68.42,51,70.54a5.28,5.28,0,0,0,8.49,0c1.57-2.11,38.53-51.84,51-70.53,11.95-17.9,18.88-31.87,18.88-50.26A74.18,74.18,0,0,0,74.12,0Zm46.42,118.51c-9.84,14.77-36.1,50.4-46.42,64.36-10.33-14-36.59-49.59-46.43-64.36-12.78-19.15-17.1-30.35-17.1-44.39a63.53,63.53,0,1,1,127,0C137.64,88.16,133.32,99.36,120.54,118.51Z" />
	</svg>
	]]
end

function icons.ship(status)
	return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 196.27 188.83">
		<path class="a" d="M183.91,132c-11.23-12.44-48.54-50.86-55.11-57.61V45.16C128.8,13.89,106.58,0,98.14,0S67.47,13.89,67.47,45.16V74.43C60.91,81.18,23.6,119.6,12.36,132-.2,146-.06,162.53,0,170.49v1.41a3.8,3.8,0,0,0,3.8,3.8H57.45a40.18,40.18,0,0,1-5.55,6.53,3.8,3.8,0,0,0,2.58,6.6H141.8a3.8,3.8,0,0,0,2.57-6.6,39.67,39.67,0,0,1-5.54-6.53h53.62a3.8,3.8,0,0,0,3.8-3.8v-1.41C196.33,162.53,196.47,146,183.91,132ZM98.14,7.61c3.91,0,23.06,10.23,23.06,37.55v90.08H75.08V45.16C75.08,17.84,94.22,7.61,98.14,7.61Zm8.8,135.23,7.14,38.39H82.19l7.14-38.39ZM7.61,168.1c0-7.87.84-20.37,10.4-31,9.31-10.31,36.81-38.75,49.46-51.79v60.27c0,7.76-2.34,15.68-5.64,22.48Zm67.47-22.48v-2.78H81.6l-7.14,38.39H62.86C69.54,172.09,75.08,158.76,75.08,145.62Zm46.73,35.6-7.14-38.38h6.53v2.78c0,13.14,5.53,26.47,12.22,35.6Zm12.64-13.12c-3.31-6.8-5.65-14.72-5.65-22.48V85.35c12.65,13,40.15,41.48,49.46,51.79,9.57,10.6,10.38,23.09,10.41,31Z" />
	</svg>
	]]
end

function icons.player(status)	
	return [[<svg class="icon ]] .. iconStatusCheck(status) .. [[" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 63.36 198">
		<circle class="a" cx="31.68" cy="17.82" r="17.82" />
		<path class="a" d="M43.56,41.58H19.8A19.86,19.86,0,0,0,0,61.38v45.54A19.85,19.85,0,0,0,11.88,125v57.12A15.89,15.89,0,0,0,27.72,198h7.92a15.89,15.89,0,0,0,15.84-15.84V125a19.85,19.85,0,0,0,11.88-18.12V61.38A19.86,19.86,0,0,0,43.56,41.58Z" />
	</svg>
	]]
end

--planetref
local function isNumber(n)  return type(n)           == 'number' end
local function isSNumber(n) return type(tonumber(n)) == 'number' end
local function isTable(t)   return type(t)           == 'table'  end
local function isString(s)  return type(s)           == 'string' end
local function isVector(v)  return isTable(v)
and isNumber(v.x and v.y and v.z) end

local function isMapPosition(m) return isTable(m) and isNumber(m.latitude  and
m.longitude and
m.altitude  and
m.bodyId    and
m.systemId) end

local deg2rad    = math.pi/180
local rad2deg    = 180/math.pi
local epsilon    = 1e-10
local num        = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' ..
num ..  ',' .. num .. '}'

local utils  = require('cpml.utils')
local vec3   = require('cpml.vec3')
local clamp  = utils.clamp

local function float_eq(a,b)
if a == 0 then return math.abs(b) < 1e-09 end
if b == 0 then return math.abs(a) < 1e-09 end
return math.abs(a - b) < math.max(math.abs(a),math.abs(b))*epsilon
end

local function formatNumber(n)
local result = string.gsub(
string.reverse(string.format('%.4f',n)),
'^0*%.?','')
return result == '' and '0' or string.reverse(result)
end

local function formatValue(obj)
if isVector(obj) then
return string.format('{x=%.3f,y=%.3f,z=%.3f}', obj.x, obj.y, obj.z)
end

if isTable(obj) and not getmetatable(obj) then
local list = {}
local nxt  = next(obj)

if type(nxt) == 'nil' or nxt == 1 then -- assume this is an array
   for i,a in ipairs(obj) do
      list[i] = formatValue(a)
   end
else
   for k,v in pairs(obj) do
      local value = formatValue(v)
      if type(k) == 'number' then
         table.insert(list, string.format('[%s]=%s', k, value))
      else
         table.insert(list, string.format('%s=%s',   k, value))
      end
   end
end
return string.format('{%s}', table.concat(list, ','))
end

if isString(obj) then
return string.format("[[%s]]", obj)
end
return tostring(obj)
end

local BodyParameters = {}
BodyParameters.__index = BodyParameters
BodyParameters.__tostring =
function(obj, indent)
local keys = {}
for k in pairs(obj) do table.insert(keys, k) end
table.sort(keys)
local list = {}
for _, k in ipairs(keys) do
local value = formatValue(obj[k])
if type(k) == 'number' then
   table.insert(list, string.format('[%s]=%s', k, value))
else
   table.insert(list, string.format('%s=%s', k, value))
end
end
if indent then
return string.format('%s%s',
indent,
table.concat(list, ',\n' .. indent))
end
return string.format('{%s}', table.concat(list, ','))
end
BodyParameters.__eq = function(lhs, rhs)
return lhs.planetarySystemId == rhs.planetarySystemId and
lhs.bodyId            == rhs.bodyId            and
float_eq(lhs.radius, rhs.radius)               and
float_eq(lhs.center.x, rhs.center.x)           and
float_eq(lhs.center.y, rhs.center.y)           and
float_eq(lhs.center.z, rhs.center.z)           and
float_eq(lhs.GM, rhs.GM)
end

local function mkBodyParameters(systemId, bodyId, radius, worldCoordinates, GM)
-- 'worldCoordinates' can be either table or vec3
assert(isSNumber(systemId),
'Argument 1 (planetarySystemId) must be a number:' .. type(systemId))
assert(isSNumber(bodyId),
'Argument 2 (bodyId) must be a number:' .. type(bodyId))
assert(isSNumber(radius),
'Argument 3 (radius) must be a number:' .. type(radius))
assert(isTable(worldCoordinates),
'Argument 4 (worldCoordinates) must be a array or vec3.' ..
type(worldCoordinates))
assert(isSNumber(GM),
'Argument 5 (GM) must be a number:' .. type(GM))
return setmetatable({planetarySystemId = tonumber(systemId),
bodyId            = tonumber(bodyId),
radius            = tonumber(radius),
center            = vec3(worldCoordinates),
GM                = tonumber(GM) }, BodyParameters)
end

local MapPosition = {}
MapPosition.__index = MapPosition
MapPosition.__tostring = function(p)
return string.format('::pos{%d,%d,%s,%s,%s}',
p.systemId,
p.bodyId,
formatNumber(p.latitude*rad2deg),
formatNumber(p.longitude*rad2deg),
formatNumber(p.altitude))
end
MapPosition.__eq       = function(lhs, rhs)
return lhs.bodyId   == rhs.bodyId              and
lhs.systemId == rhs.systemId            and
float_eq(lhs.latitude,   rhs.latitude)  and
float_eq(lhs.altitude,   rhs.altitude)  and
(float_eq(lhs.longitude, rhs.longitude) or
float_eq(lhs.latitude, math.pi/2)      or
float_eq(lhs.latitude, -math.pi/2))
end

local function mkMapPosition(overload, bodyId, latitude, longitude, altitude)
local systemId = overload

if isString(overload) and not longitude and not altitude and
not bodyId    and not latitude then
systemId, bodyId, latitude, longitude, altitude =
string.match(overload, posPattern)
assert(systemId, 'Argument 1 (position string) is malformed.')
else
assert(isSNumber(systemId),
'Argument 1 (systemId) must be a number:' .. type(systemId))
assert(isSNumber(bodyId),
'Argument 2 (bodyId) must be a number:' .. type(bodyId))
assert(isSNumber(latitude),
'Argument 3 (latitude) must be in degrees:' .. type(latitude))
assert(isSNumber(longitude),
'Argument 4 (longitude) must be in degrees:' .. type(longitude))
assert(isSNumber(altitude),
'Argument 5 (altitude) must be in meters:' .. type(altitude))
end
systemId  = tonumber(systemId)
bodyId    = tonumber(bodyId)
latitude  = tonumber(latitude)
longitude = tonumber(longitude)
altitude  = tonumber(altitude)

if bodyId == 0 then -- this is a hack to represent points in space
return setmetatable({latitude  = latitude,
longitude = longitude,
altitude  = altitude,
bodyId    = bodyId,
systemId  = systemId}, MapPosition)
end
return setmetatable({latitude  = deg2rad*clamp(latitude, -90, 90),
longitude = deg2rad*(longitude % 360),
altitude  = altitude,
bodyId    = bodyId,
systemId  = systemId}, MapPosition)
end

local PlanetarySystem = {}
PlanetarySystem.__index = PlanetarySystem

PlanetarySystem.__tostring =
function (obj, indent)
local sep = indent and (indent .. '  ' )
local bdylist = {}
local keys = {}
for k in pairs(obj) do table.insert(keys, k) end
table.sort(keys)
for _, bi in ipairs(keys) do
bdy = obj[bi]
local bdys = BodyParameters.__tostring(bdy, sep)
if indent then
table.insert(bdylist,
string.format('[%s]={\n%s\n%s}',
bi, bdys, indent))
else
table.insert(bdylist, string.format('  [%s]=%s', bi, bdys))
end
end
if indent then
return string.format('\n%s%s%s',
indent,
table.concat(bdylist, ',\n' .. indent),
indent)
end
return string.format('{\n%s\n}', table.concat(bdylist, ',\n'))
end

local function mkPlanetarySystem(systemReferenceTable)
local atlas = {}
local pid
for _, v in pairs(systemReferenceTable) do
local id = v.planetarySystemId

if id == nil then
id = 0
v.planetarySystemId = id
end

if type(id) ~= 'number' then
error('Invalid planetary system ID: ' .. tostring(id))
elseif pid and id ~= pid then
error('Mismatch planetary system IDs: ' .. id .. ' and '
.. pid)
end
local bid = v.bodyId

if bid == nil then
bid      = v.id
v.bodyId = bid
end
if type(bid) ~= 'number' then
error('Invalid body ID: ' .. tostring(bid))
elseif atlas[bid] then
error('Duplicate body ID: ' .. tostring(bid))
end
v.center = vec3(v.center)
atlas[bid] = setmetatable(v, BodyParameters)
pid = id
end
return setmetatable(atlas, PlanetarySystem)
end

PlanetaryReference = {}

local function mkPlanetaryReference(referenceTable)
return setmetatable({ galaxyAtlas = referenceTable or {} },
PlanetaryReference)
end

PlanetaryReference.__index        =
function(t,i)
if type(i) == 'number' then
local system = t.galaxyAtlas[i]
return mkPlanetarySystem(system)
end
return rawget(PlanetaryReference, i)
end
PlanetaryReference.__pairs        =
function(obj)
return  function(t, k)
local nk, nv = next(t, k)
return nk, nv and mkPlanetarySystem(nv)
end, obj.galaxyAtlas, nil
end
PlanetaryReference.__tostring     =
function (obj)
local pslist = {}
for _,ps in pairs(obj or {}) do
local psi = ps:getPlanetarySystemId()
local pss = PlanetarySystem.__tostring(ps, '    ')
table.insert(pslist,
string.format('  [%s]={%s\n  }', psi, pss))
end
return string.format('{\n%s\n}\n', table.concat(pslist,',\n'))
end

PlanetaryReference.BodyParameters = mkBodyParameters
PlanetaryReference.MapPosition    = mkMapPosition
PlanetaryReference.PlanetarySystem = mkPlanetarySystem

function PlanetaryReference.createBodyParameters(planetarySystemId,
bodyId,
surfaceArea,
aPosition,
verticalAtPosition,
altitudeAtPosition,
gravityAtPosition)
assert(isSNumber(planetarySystemId),
'Argument 1 (planetarySystemId) must be a number:' ..
type(planetarySystemId))
assert(isSNumber(bodyId),
'Argument 2 (bodyId) must be a number:' .. type(bodyId))
assert(isSNumber(surfaceArea),
'Argument 3 (surfaceArea) must be a number:' .. type(surfaceArea))
assert(isTable(aPosition),
'Argument 4 (aPosition) must be an array or vec3:' ..
type(aPosition))
assert(isTable(verticalAtPosition),
'Argument 5 (verticalAtPosition) must be an array or vec3:' ..
type(verticalAtPosition))
assert(isSNumber(altitudeAtPosition),
'Argument 6 (altitude) must be in meters:' ..
type(altitudeAtPosition))
assert(isSNumber(gravityAtPosition),
'Argument 7 (gravityAtPosition) must be number:' ..
type(gravityAtPosition))
local radius   = math.sqrt(surfaceArea/4/math.pi)
local distance = radius + altitudeAtPosition
local center   = vec3(aPosition) + distance*vec3(verticalAtPosition)
local GM       = gravityAtPosition * distance * distance
return mkBodyParameters(planetarySystemId, bodyId, radius, center, GM)
end

PlanetaryReference.isMapPosition  = isMapPosition

function PlanetaryReference:getPlanetarySystem(overload)
if self.galaxyAtlas then
local planetarySystemId = overload

if isMapPosition(overload) then
planetarySystemId = overload.systemId
end

if type(planetarySystemId) == 'number' then
local system = self.galaxyAtlas[planetarySystemId]
if system then
if getmetatable(system) ~= PlanetarySystem then
system = mkPlanetarySystem(system)
end
return system
end
end
end
return nil
end

function PlanetarySystem:castIntersections(origin,
direction,
sizeCalculator,
bodyIds)
local sizeCalculator = sizeCalculator or
function (body) return 1.05*body.radius end
local candidates = {}

if bodyIds then
for _,i in ipairs(bodyIds) do candidates[i] = self[i] end
else
bodyIds = {}
for k,body in pairs(self) do
table.insert(bodyIds, k)
candidates[k] = body
end
end
local function compare(b1,b2)
local v1 = candidates[b1].center - origin
local v2 = candidates[b2].center - origin
return v1:len() < v2:len()
end
table.sort(bodyIds, compare)
local dir = direction:normalize()

for i, id in ipairs(bodyIds) do
local body   = candidates[id]
local c_oV3  = body.center - origin
local radius = sizeCalculator(body)
local dot    = c_oV3:dot(dir)
local desc   = dot^2 - (c_oV3:len2() - radius^2)

if desc >= 0 then
local root     = math.sqrt(desc)
local farSide  = dot + root
local nearSide = dot - root
if nearSide > 0 then
return body, farSide, nearSide
elseif farSide > 0 then
return body, farSide, nil
end
end
end
return nil, nil, nil
end

function PlanetarySystem:closestBody(coordinates)
assert(type(coordinates) == 'table', 'Invalid coordinates.')
local minDistance2, body
local coord = vec3(coordinates)

for _,params in pairs(self) do
local distance2 = (params.center - coord):len2()
if not body or distance2 < minDistance2 then
body         = params
minDistance2 = distance2
end
end
return body
end

function PlanetarySystem:convertToBodyIdAndWorldCoordinates(overload)
local mapPosition = overload
if isString(overload) then
mapPosition = mkMapPosition(overload)
end

if mapPosition.bodyId == 0 then
return 0, vec3(mapPosition.latitude,
mapPosition.longitude,
mapPosition.altitude)
end
local params = self:getBodyParameters(mapPosition)

if params then
return mapPosition.bodyId,
params:convertToWorldCoordinates(mapPosition)
end
end

function PlanetarySystem:getBodyParameters(overload)
local bodyId = overload

if isMapPosition(overload) then
bodyId = overload.bodyId
end
assert(isSNumber(bodyId),
'Argument 1 (bodyId) must be a number:' .. type(bodyId))

return self[bodyId]
end

function PlanetarySystem:getPlanetarySystemId()
local k, v = next(self)
return v and v.planetarySystemId
end

function PlanetarySystem:netGravity(coordinates)
assert(type(coordinates) == 'table', 'Invalid coordinates.')
local netGravity   = vec3()
local coord        = vec3(coordinates)
local maxG, body

for _,params in pairs(self) do
local radial   = params.center - coord
local len2     = radial:len2()
local g        = params.GM/len2
if not body or g > maxG then
body       = params
maxG       = g
end
netGravity = netGravity + g/math.sqrt(len2)*radial
end
return body, netGravity
end

function BodyParameters:convertToMapPosition(worldCoordinates)
assert(isTable(worldCoordinates),
'Argument 1 (worldCoordinates) must be an array or vec3:' ..
type(worldCoordinates))
local worldVec  = vec3(worldCoordinates)

if self.bodyId == 0 then
return setmetatable({latitude  = worldVec.x,
longitude = worldVec.y,
altitude  = worldVec.z,
bodyId    = 0,
systemId  = self.planetarySystemId}, MapPosition)
end
local coords    = worldVec - self.center
local distance  = coords:len()
local altitude  = distance - self.radius
local latitude  = 0
local longitude = 0

if not float_eq(distance, 0) then
local phi = math.atan(coords.y, coords.x)
longitude = phi >= 0 and phi or (2*math.pi + phi)
latitude  = math.pi/2 - math.acos(coords.z/distance)
end
return setmetatable({latitude  = latitude,
longitude = longitude,
altitude  = altitude,
bodyId    = self.bodyId,
systemId  = self.planetarySystemId}, MapPosition)
end

function BodyParameters:convertToWorldCoordinates(overload)
local mapPosition = isString(overload) and
mkMapPosition(overload) or overload
if mapPosition.bodyId == 0 then
return vec3(mapPosition.latitude,
mapPosition.longitude,
mapPosition.altitude)
end
assert(isMapPosition(mapPosition),
'Argument 1 (mapPosition) is not an instance of "MapPosition".')
assert(mapPosition.systemId == self.planetarySystemId,
'Argument 1 (mapPosition) has a different planetary system ID.')
assert(mapPosition.bodyId == self.bodyId,
'Argument 1 (mapPosition) has a different planetary body ID.')
local xproj = math.cos(mapPosition.latitude)
return self.center + (self.radius + mapPosition.altitude) *
vec3(xproj*math.cos(mapPosition.longitude),
xproj*math.sin(mapPosition.longitude),
math.sin(mapPosition.latitude))
end

function BodyParameters:getAltitude(worldCoordinates)
return (vec3(worldCoordinates) - self.center):len() - self.radius
end

function BodyParameters:getDistance(worldCoordinates)
return (vec3(worldCoordinates) - self.center):len()
end

function BodyParameters:getGravity(worldCoordinates)
local radial = self.center - vec3(worldCoordinates)
local len2   = radial:len2()
return (self.GM/len2) * radial/math.sqrt(len2)
end

return setmetatable(PlanetaryReference,
{ __call = function(_,...)
return mkPlanetaryReference(...)
end })

--pipe distance
--deprecated code
increment = 5
heightBetweenAngles = 30
playerName = system.getPlayerName(unit.getMasterPlayerId())
xDelta = -238
yDelta = -108
wheelDelta = -200
mapScale = .99999
planetScale = 1200
aliothsize = 8000
moonScale = 3000
map = 0
warpScan = 0
targetList = ''
altb=false
pipelocalization = 1 --export: Pipe-localization: 1 - english, 2 - french, 3 - german
function calcDistance(origCenter, destCenter, location)
local pipe = (destCenter - origCenter):normalize()
local r = (location-origCenter):dot(pipe) / pipe:dot(pipe)
if r <= 0. then
return (location-origCenter):len()
elseif r >= (destCenter - origCenter):len() then
return (location-destCenter):len()
end
local L = origCenter + (r * pipe)
pipeDistance =  (L - location):len()

return pipeDistance
end
function calcDistanceStellar(stellarObjectOrigin, stellarObjectDestination, currenLocation)
local origCenter = vec3(stellarObjectOrigin.center)
local destCenter = vec3(stellarObjectDestination.center)

return calcDistance(origCenter, destCenter, currenLocation)
end
refreshPipeData = function (currentLocation)
while true do
local smallestDistance = nil;
local nearestPlanet = nil;

for obj in pairs(_stellarObjects) do
if (_stellarObjects[obj].type[1] == 'Planet' or _stellarObjects[obj].name[1] == 'Sanctuary') then
local planetCenter = vec3(_stellarObjects[obj].center)
local distance = vec3(currentLocation - planetCenter):len()

if (smallestDistance == nil or distance < smallestDistance) then
smallestDistance = distance;
nearestPlanet = obj;
end
end
end
if showClosestPlanet == true then
planetInfoData.value = _stellarObjects[nearestPlanet].name[1]
system.updateData(planetInfoDataId, json.encode(planetInfoData))
end
if showClosestPipe == true or showClosestPipeDist == true or
showAliothClosestPipe == true or showAliothClosestPipeDist == true then
closestPlanet = _stellarObjects[nearestPlanet]
nearestPipeDistance = nil
nearestAliothPipeDistance= nil
for obj in pairs(_stellarObjects) do
if (_stellarObjects[obj].type[1] == 'Planet' or _stellarObjects[obj].name[1] == 'Sanctuary') then
for obj2 in pairs(_stellarObjects) do
   if (obj2 > obj and (_stellarObjects[obj2].type[1] == 'Planet' or _stellarObjects[obj2].name[1] == 'Sanctuary')) then
      pipeDistance = calcDistanceStellar(_stellarObjects[obj], _stellarObjects[obj2], currentLocation)
      if nearestPipeDistance == nil or pipeDistance < nearestPipeDistance then
         nearestPipeDistance = pipeDistance;
         sortestPipeKeyId = obj;
         sortestPipeKey2Id = obj2;
      end
      if _stellarObjects[obj].name[1] == "Alioth" and (nearestAliothPipeDistance == nil or pipeDistance < nearestAliothPipeDistance) then
         nearestAliothPipeDistance = pipeDistance;
         sortestAliothPipeKeyId = obj;
         sortestAliothPipeKey2Id = obj2;
      end
   end
end
end
end
if showClosestPipe == true then
closestPipeData.value = _stellarObjects[sortestPipeKeyId].name[pipelocalization] .. " - " .. _stellarObjects[sortestPipeKey2Id].name[pipelocalization]
system.updateData(closestPipeDataId, json.encode(closestPipeData))
end
if showClosestPipeDist == true then
closestPipeDistData.value = string.format("%03.2f", nearestPipeDistance / 200000.0)
system.updateData(closestPipeDistDataId, json.encode(closestPipeDistData))
end
if showAliothClosestPipe == true then
closestAliothPipeData.value = _stellarObjects[sortestAliothPipeKeyId].name[pipelocalization] .. " - " .. _stellarObjects[sortestAliothPipeKey2Id].name[pipelocalization]
system.updateData(closestAliothPipeDataId, json.encode(closestAliothPipeData))
end
if showAliothClosestPipeDist == true then
closestAliothPipeDistData.value = string.format("%03.2f", nearestAliothPipeDistance / 200000.0)
system.updateData(closestAliothPipeDistDataId, json.encode(closestAliothPipeDistData))
end
end
currentLocation = coroutine.yield()
end
end
local panelName = "Pipe info"
showClosestPlanet = true
showClosestPipe = true
showClosestPipeDist = true
showAliothClosestPipe = false
showAliothClosestPipeDist = false
-- panel setup
--panelid = system.createWidgetPanel(panelName)
if showClosestPlanet == true then
-- closest planet
widgetClosestPlanetId = system.createWidget(panelid, "value")
planetInfoData = {
value = "XYZ",
unit = "",
label = "Closest planet"
}
planetInfoDataId = system.createData(json.encode(planetInfoData))
system.addDataToWidget(planetInfoDataId, widgetClosestPlanetId)
end
if showClosestPipe == true then
-- showClosestPipe
closestPipeId = system.createWidget(panelid, "value")
closestPipeData = {
value = "XYZ",
unit = "",
label = "Closest Pipe"
}
closestPipeDataId = system.createData(json.encode(closestPipeData))
system.addDataToWidget(closestPipeDataId, closestPipeId)
end
if showClosestPipeDist == true then
-- showClosestPipeDist
closestPipeDistId = system.createWidget(panelid, "value")
closestPipeDistData = {
value = "0.0",
unit = "SU",
label = "Pipe dist."
}
closestPipeDistDataId = system.createData(json.encode(closestPipeDistData))
system.addDataToWidget(closestPipeDistDataId, closestPipeDistId)
end
-- showClosestPipe
closestAliothPipeId = system.createWidget(panelid, "value")
closestAliothPipeData = {
value = "XYZ",
unit = "",
label = "Alioth Pipe"
}
closestAliothPipeDataId = system.createData(json.encode(closestAliothPipeData))
system.addDataToWidget(closestAliothPipeDataId, closestAliothPipeId)
if showAliothClosestPipeDist == true then
-- showClosestPipeDist
closestAliothPipeDistId = system.createWidget(panelid, "value")
closestAliothPipeDistData = {
value = "0.0",
unit = "SU",
label = "Alioth pipe dist."
}
closestAliothPipeDistDataId = system.createData(json.encode(closestAliothPipeDistData))
system.addDataToWidget(closestAliothPipeDistDataId, closestAliothPipeDistId)
end
refreshCoroutine = coroutine.create(refreshPipeData)
coroutine.resume( refreshCoroutine, vec3(core.getConstructWorldPos()))
galaxyReference = PlanetaryReference(atlas)
helios = galaxyReference[0]
closestPlanet1 = helios[helios:closestBody(core.getConstructWorldPos()).bodyId]
if db.getStringValue(15) ~= "" then
asteroidPOS = db.getStringValue(15)
else
asteroidPOS = ''
end
markerName = "Asteroid" --export:
if markerName == "" then markerName = "Asteroid" end
asteroidcoord = {}
if asteroidPOS ~= "" then
asteroidcoord = zeroConvertToWorldCoordinatesG(asteroidPOS,system)
else
asteroidcoord = {0,0,0}
end
safew=''
function pD()
pipeD = ''
if nearestPipeDistance >= 100000 then
pipeD = ''..string.format('%0.2f', nearestPipeDistance/200000)..' su'
elseif nearestPipeDistance >= 1000 and nearestPipeDistance < 100000 then
pipeD = ''..string.format('%0.1f', nearestPipeDistance/1000)..' km'
else
pipeD = ''..string.format('%0.0f', nearestPipeDistance)..' m'
end
if nearestPipeDistance >= 600000 then
return closestPipeData.value.. '<br>' .. '<greencolor1>'..pipeD..'</greencolor1>'
elseif nearestPipeDistance >= 400000 and nearestPipeDistance <= 600000 then
return closestPipeData.value.. '<br>' .. '<orangecolor>'..pipeD..'</orangecolor>'
elseif nearestPipeDistance < 400000 then
return closestPipeData.value.. '<br>' .. '<redcolor1>'..pipeD..'<redcolor1>'
end
end
shipName = core.getConstructName()
conID = (""..core.getConstructId()..""):sub(-3)
shipINFO = '**'..conID..' - '..shipName..'**'
shipINFO2 = '**'..conID..' - '..shipName..':**'
bhelper = false
system.showHelper(0)
cPlan = ''
distS = ''
safetext=''
szsafe=true
distZ = 0
function safeZone()
end
tz1=0
tz2=0
varvw = 0
varvh = 0
function indexSort(tbl)
local idx = {}
for i = 1, #tbl do idx[i] = i end
table.sort(idx, function(a, b) return tbl[a] > tbl[b] end)
return (table.unpack or unpack)(idx)
end
function getResRatioBy2HighestDamage(stress)
local resRatio = {0,0,0,0}
local h1, h2 = indexSort(stress)
if stress[h2] > 0 then
resRatio[h1] = resMAX/2
resRatio[h2] = resMAX/2
else
resRatio[h1] = resMAX
end
return resRatio
end
newhit=0
varcombat = core.getPvPTimer()
if varcombat > 300 then newhit = 1 end
lalt=false
buttonC=false
buttonSpace=false
AMcolor = "#fca503"
EMcolor = "#fca503"
KIcolor = "#fca503"
THcolor = "#fca503"
stress = {0,0,0,0}
AMval = 0
EMval = 0
KIval = 0
THval = 0
resMAX = shield.getResistancesPool()
function getRes(stress, resMAX)
local res = {0.15,0.15,0.15,0.15}
if stress[1] >= stress[2] and
stress[1] >= stress[3] and
stress[1] > stress[4] then
res = {resMAX,0,0,0}
elseif stress[2] >= stress[1] and
stress[2] >= stress[3] and
stress[2] > stress[4] then
res = {0,resMAX,0,0}
elseif stress[3] >= stress[1] and
stress[3] >= stress[2] and
stress[3] > stress[4] then
res = {0,0,resMAX,0}
elseif stress[4] >= stress[1] and
stress[4] >= stress[2] and
stress[4] > stress[3] then
res = {0,0,0,resMAX}
else
system.print("ERR1")
end
return res
end
shoteCount = 0
lastShotTime = system.getTime()
Shield_Auto_Calibration = true --export: (AUTO/MANUAL) shield mode
Shield_Calibration_Max = true --export: (MAX/50) calibration of the entire shield power by the largest resist based on DPS
Show_vanilla_shield_widget = false --export: Show shield widget
Show_warp_widget = true --export: Show warp widget
Show_combatstress_widget = true --export: Show CCS widget
Departure_export = 2 --export: Departure ID planet
Destination_export = 9 --export: Destination ID planet
SU = 10 --export:
timeZone = 3 --export: от 1 до 24
collectgarbages = true --export:
local CFCS_Background_Color = "#142027" --export: Backgroung color CFCS system
local CFCS_PipeText_Color = "#FFFFFF" --export: Pipe text color
local CFCS_PipeY = -0.1 --export:
local CFCS_PipeX = 15.5 --export:
local CFCS_Y = 50 --export:
local CFCS_TextY = 12 --export:
local CFCS_RightBlock_X = 30 --export:
local CFCS_LeftBlock_X = 12 --export:
if Show_vanilla_shield_widget then shield.show() end
if Show_warp_widget then
if warpdrive ~= nil then warpdrive.show() end
end
if Show_combatstress_widget then
coreCombatStressPanelId = system.createWidgetPanel("Core combat stress")
coreCombatStressgWidgetId = system.createWidget(coreCombatStressPanelId,"core_stress")
system.addDataToWidget(core.getDataId(),coreCombatStressgWidgetId)
end
docki=0
dpstimer = ""
resCLWN = ""
ventCLWN = ""
damageText = ""
--щит
if Shield_Auto_Calibration
then
if Shield_Calibration_Max then
shieldText = "SHIELD (AUTO,MAX)"
end
if not Shield_Calibration_Max then
shieldText = "SHIELD (AUTO,50)"
end
else
if Shield_Calibration_Max then
shieldText = "SHIELD (MANUAL,MAX)"
end

if not Shield_Calibration_Max then
shieldText = "SHIELD (MANUAL,50)"
end
end
function UTCscaner()
local T = system.getTime() - timeZone * 3600
return T
end

brakeText = ""
if shield.getState() == 0 then
shieldColor = "#fc033d"
else
shieldColor = "#2ebac9"
end
resisttime = 0
venttime = 0
venttimemax = shield.getVentingMaxCooldown()
resisttimemax = shield.getResistancesMaxCooldown()
tormoz=0
shieldHP = ''
HPS = 100
shieldMaxHP = shield.getMaxShieldHitpoints()
local data2=shield.getResistances()
AMres = math.floor(data2[1]/resMAX*100)
EMres = math.floor(data2[2]/resMAX*100)
KIres = math.floor(data2[3]/resMAX*100)
THres = math.floor(data2[4]/resMAX*100)

--Planet radar
YScreenRes=system.getScreenHeight()
XScreenRes=system.getScreenWidth()
message=''
DisplayRadar = false
function drawonradar(coordonate,PlaneteName)
local constructUp = vec3(core.getConstructWorldOrientationUp())
local constructForward = vec3(core.getConstructWorldOrientationForward())
local constructRight = vec3(core.getConstructWorldOrientationRight())
local ConstructWorldPos = vec3(core.getConstructWorldPos())
local ToCible=coordonate-ConstructWorldPos
local Xcoord = mySignedAngleBetween(ToCible, constructForward, constructUp)/math.pi --*RadarR
local Ycoord = mySignedAngleBetween(ToCible, constructForward, constructRight)/math.pi --*RadarR+RadarY
local XcoordR=Xcoord*math.sqrt(1-Ycoord*Ycoord/2)*RadarR+RadarX
local YcoordR=Ycoord*math.sqrt(1-Xcoord*Xcoord/2)*RadarR+RadarY
svgradar=svgradar..string.format([[
<circle cx="%f" cy="%f" r="4" fill="red" />
<text x="%f" y="%f" font-size="12px" fill="yellow">%s</text>
]],XcoordR,YcoordR,XcoordR+4,YcoordR,PlaneteName)
end

function mySignedAngleBetween(vecteur1, vecteur2, planeNormal)

local normVec1 = vecteur1:project_on_plane(planeNormal):normalize()
local normVec2 = vecteur2:normalize()

local angle = math.acos(normVec1:dot(normVec2))
local crossProduct = vecteur1:cross(vecteur2)

if crossProduct:dot(planeNormal) < 0 then
return -angle
else
return angle
end
end
Planet = atlas[0]
DepartureCenter = vec3(Planet[Departure_export].center)
DestinationCenter = vec3(Planet[Destination_export].center)
DepartureCenterName = Planet[Departure_export].name[1]
DestinationCenterName = Planet[Destination_export].name[1]
unit.hide()
mybr=false

local opt1=system.getActionKeyName('option1')
local opt2=system.getActionKeyName('option2')
local opt3=system.getActionKeyName('option3')
local opt4=system.getActionKeyName('option4')
local opt5=system.getActionKeyName('option5')
local opt6=system.getActionKeyName('option6')
local opt7=system.getActionKeyName('option7')
local opt8=system.getActionKeyName('option8')
local opt9=system.getActionKeyName('option9')
local shifttext=system.getActionKeyName('lshift')
local alttext=system.getActionKeyName('lalt')
local forwardtext=system.getActionKeyName('forward')
local backwardtext=system.getActionKeyName('backward')
local uptext=system.getActionKeyName('up')
local downtext=system.getActionKeyName('down')
local lefttext=system.getActionKeyName('left')
local antigravtext = system.getActionKeyName('antigravity')
local righttext=system.getActionKeyName('right')
local yawlefttext=system.getActionKeyName('yawleft')
local yawrighttext=system.getActionKeyName('yawright')
local braketext1=system.getActionKeyName('brake')
local lighttext=system.getActionKeyName('light')

helperClass = [[<div class="helper">
]]..shifttext..[[ + ]]..opt1..[[: set destination to departure planet<br>
]]..shifttext..[[ + ]]..opt2..[[: set destination to closest pipe between departure and destination planets<br>
]]..shifttext..[[ + ]]..opt3..[[: set destination to destination planet<br>
]]..opt1..[[: set destination to departure LUA planet<br>
]]..opt2..[[: set destination to pipe center between LUA departure and destination planets<br>
]]..opt3..[[: set destination to destination LUA planet<br>
]]..uptext..[[ + ]]..opt4..[[: send current location coordinates to LUA channel<br>
]]..antigravtext..[[: send the ID of the selected target to the LUA channel and to the screen<br>
]]..opt5..[[: 3D map<br>
]]..opt6..[[: set shield resists manually based on calculated DPS<br>
]]..opt7..[[: 2D planet radar<br>
]]..opt8..[[: enable/disable the shield<br>
]]..opt9..[[: start/stop shield venting<br>
]]..uptext..[[ + ]]..forwardtext..[[: (MAX/50) calibration of the entire shield power by the largest resist based on DPS<br>
]]..uptext..[[ + ]]..backwardtext..[[: (AUTO/MANUAL) shield mode<br>
]]..uptext..[[ + ]]..yawlefttext..[[: 100% shield power on AM resist<br>
]]..uptext..[[ + ]]..yawrighttext..[[: 100% shield power on EM resist<br>
]]..uptext..[[ + ]]..lefttext..[[: 100% shield power on KI resist<br>
]]..uptext..[[ + ]]..righttext..[[: 100% shield power on TH resist<br>
]]..lighttext..[[: set position from the map active<br>
]]..alttext..[[ + ]]..uptext..[[: show/hide locked targets on the radar widget<br>
]]..alttext..[[ + ]]..downtext..[[: enemies/allies on the radar widget<br>
]]..downtext..[[ + ]]..uptext..[[: disable radar focus mode<br>
]]..braketext1..[[ + ]]..uptext..[[: HOLD BRAKE<br><br>
Shield profiles:<br>
]]..downtext..[[ + ]]..yawlefttext..[[: lasers/cannons 33%/33%/33%<br>
]]..downtext..[[ + ]]..forwardtext..[[: cannons 50%/50%<br>
]]..downtext..[[ + ]]..yawrighttext..[[: lasers 50%/50%<br>
]]..downtext..[[ + ]]..lefttext..[[: railguns 50%/50%<br>
]]..downtext..[[ + ]]..righttext..[[: missiles 50%/50%<br>
]]..downtext..[[ + ]]..backwardtext..[[: universal profile 25%/25%/25%/25%<br>
u: universal profile 25%/25%/25%/25% (LUA chat)<br>
l:  50%/50% (LUA chat)<br>
c: cannons 50%/50% (LUA chat)<br>
m - missiles 50%/50% (LUA chat)<br>
r - railguns 50%/50% (LUA chat)<br><br>
LUA chat commands:<br>
m::pos - add position to map<br>
f last 3 digits of ID - set target for radar focus<br>
res - disable radar focus mode<br>
safe - enable/disable notofications in the safe zone<br>
ang - enable/disable display of angular velocity<br>
drop - undock all structures<br>
sw - show shield widget<br>
swd - show warpdrive widget<br>
sz - destination to closest safe-zone<br>
szс - destination to safe-zone<br>
helper - show/hide build helper</div>]]

html1 = [[
<style>
.main1 {
position: fixed;
width: 11em;
padding: 1vh;
top: 1vh;
left: 50%;
transform: translateX(-50%);
text-align: center;
background: #142027;
color: white;
font-family: "Lucida" Grande, sans-serif;
font-size: 1.5em;
border-radius: 5vh;
border: 0.2vh solid;
border-color: #fca503;
</style>
<div class="main1">BRAKE ENGAGED</div>]]
dis=0
accel=0
resString = ""
streamtext2=""
thr1=""
throttle1=0
fuel1=0
system.showScreen(1)
hudang1 = [[
<style>
.hudversion1 {
position: fixed;
top: 32vh;
color: #fca503;
left: 2vw;
font-family: "Times New Roman", Times, serif;
font-size: 1.1em;
font-weight: bold;
text-align: left;
}</style>]]
hudang2 = [[
<style>
.hudversion2 {
position: fixed;
top: 34vh;
color: #fca503;
left: 2vw;
font-family: "Times New Roman", Times, serif;
font-size: 1.1em;
font-weight: bold;
text-align: left;
}</style>]]
blink=1
shieldAlarm = false
alarmTimer = false
t2=nil
function renderNiceHud()
local speed = math.floor(vec3(core.getWorldVelocity()):len() * 3.6)
local warningmsg = ''
if HPS < 100 and HPS > 75 then
   HPcolor = "yellow"
elseif HPS <= 75 and HPS > 50 then
   HPcolor = "#ff6600"
elseif HPS <= 50 then
   HPcolor = "#fc033d"

   warningmsg = [[<style>
   .warningmsg {
      position: fixed;
      width: 8em;
      padding: 1vh;
      top: 22vh;
      left: 50%;
      transform: translateX(-50%);
      text-align: center;
      background: #142027;
      color: #fc033d;
      font-family: "Lucida" Grande, sans-serif;
      font-size: 1.5em;
      border-radius: 5vh;
      border: 0.2vh solid;
      border-color: #fca503;
      </style>
      <div class="warningmsg">SHIELD LOW!</div>]]

   else
      HPcolor = "#6affb1"
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

   if HPS <= 35 then
      shieldAlarm=true
      if alarmTimer == true then
         warningmsg = [[<style>
         .warningmsg {
            position: fixed;
            width: 8em;
            padding: 1vh;
            top: 22vh;
            left: 50%;
            transform: translateX(-50%);
            text-align: center;
            background: #142027;
            color: #fc033d;
            opacity: ]]..blink..[[;
            font-family: "Lucida" Grande, sans-serif;
            font-size: 1.5em;
            border-radius: 5vh;
            border: 0.2vh solid;
            border-color: #fca503;
            </style>
            <div class="warningmsg">SHIELD LOW!</div>]]
         end
      else
         shieldAlarm = false
      end

      if lalt == true and newhit == 1 then
         htmlm = [[
         <style>
         html, body {
            margin: 0;
            padding: 0;
            background: transparent;
            position: relative;
         }
         .telemetry {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            right: ]]..CFCS_RightBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry > div.numbers {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry > div.numbers > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: left;
            width: 60px;
         }
         .telemetry > div.numbers > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: 4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry > div.numbers > h2 > span {
            display:block;
            font-size: 20px;
         }

         .telemetry2 {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            left: ]]..CFCS_LeftBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry2 > div.numbers2 {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry2 > div.numbers2 > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: right;
            width: 60px;
         }
         .telemetry2 > div.numbers2 > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: -40.4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry2 > div.numbers2 > h2 > span {
            display:block;
            font-size: 20px;
            text-align: right;
         }
         .shield
         {
            margin-left:403.2px;
            margin-top:-237.2px;
         }
         .fuel
         {
            margin-left:347px;
            margin-top:-104px;
         }
         HPcolor {
            color: ]]..HPcolor..[[;
         }
         orangecolor {
            color: #fca503;
         }
         redcolor {
            color: #fc033d;
         }
         greencolor {
            color: #2ebac9;
         }
         amcolor {
            color: ]]..AMcolor..[[;
         }
         emcolor {
            color: ]]..EMcolor..[[;
         }

         kicolor {
            color: ]]..KIcolor..[[;
         }
         thcolor {
            color: ]]..THcolor..[[;
         }
         powercolor {
            font-size: 15px;
            color: #b6dfed;
         }
         .helper {
            max-width: 24vw;
            opacity: 0.9;
            padding: 2px;
            position:fixed;
            top:8.2vh;
            left:0.5vw;
            text-align: left;
            background:  #2C2F33;
            color: #FFFFFF;
            font-family: "Times New Roman", Times, serif;
            font-size: 1.3vmin;
            border-radius: 5px;
            border: 2px solid black;
         }
         .safez {
            width: auto;
            padding: 2px;
            position:fixed;
            top:-0.1vh;
            right:0;
            text-align: right;
            color: #FFFFFF;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         .pipe {
            width: auto;
            padding-left: 35px;
            padding-right: 35px;
            padding-top: 2px;
            padding-bottom: 2px;
            position:fixed;
            top: ]]..CFCS_PipeY..[[vh;
            right: ]]..CFCS_PipeX..[[vw;
            text-align: center;
            color: ]]..CFCS_PipeText_Color..[[;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         redcolor1 {
            color: #fc033d;
         }
         greencolor1 {
            color: #6affb1;
         }
         </style>
         <div class="telemetry">
         <div class="numbers">
         <div>]]..throttle1..[[</div>
         <h2>THRUST<span>%</span></h2>
         </div>
         <div class="numbers">
         <div>]]..speed..[[</div>
         <h2>SPEED<span>Km/h</span></h2>
         </div>
         <div class="numbers">
         <div>]]..accel..[[</div>
         <h2>ACCEL<span>G</span></h2>
         </div>
         <div class="numbers">
         <div>]]..resString..[[</div>
         <h2>Brake-distance<span>]]..brakeText..[[</span></h2>
         </div>
         </div>
         <div class="telemetry2">
         <div class="numbers2">
         <div><redcolor>]]..ventCLWN..[[</redcolor> <orangecolor>]]..resCLWN..[[</orangecolor> <HPcolor>]]..shieldHP..[[</HPcolor></div>
         <h2>]]..shieldText..[[<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..fuel1..[[</div>
         <h2>FUEL<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..AMres..[[<powercolor>PW </powercolor><amcolor>]]..AMval..[[</amcolor></div>
         <h2>AM<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..EMres..[[<powercolor>PW </powercolor><emcolor>]]..EMval..[[</emcolor></div>
         <h2>EM<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..KIres..[[<powercolor>PW </powercolor><kicolor>]]..KIval..[[</kicolor></div>
         <h2>KI<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..THres..[[<powercolor>PW </powercolor><thcolor>]]..THval..[[</thcolor></div>
         <h2>TH<span>%</span></h2>
         </div>
         <div class="shield">
         <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100" fill="none" stroke="]]..shieldColor..[[" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shield"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
         </div>
         <div class="fuel">
         <svg viewBox="0 0 100 100" width="100" height="100" xmlns="http://www.w3.org/2000/svg">
         <g fill="none" fill-rule="evenodd">
         <path d="M68 63c3.038 0 5.5-2.493 5.5-5.567 0-2.05-1.833-5.861-5.5-11.433-3.667 5.572-5.5 9.383-5.5 11.433C62.5 60.507 64.962 63 68 63z" fill="#FFB12C"/>
         </g>
         </svg>
         </div>
         </div>
         ]]..helperClass..[[
         <div class="safez">]]..safetext..[[</div>
         <div class="pipe">]]..pD()..[[</div>]]

      end

      if lalt == false and newhit == 1 then
         htmlm = [[
         <style>
         html, body {
            margin: 0;
            padding: 0;
            background: transparent;
            position: relative;
         }
         .telemetry {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            right: ]]..CFCS_RightBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry > div.numbers {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry > div.numbers > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: left;
            width: 60px;
         }
         .telemetry > div.numbers > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: 4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry > div.numbers > h2 > span {
            display:block;
            font-size: 20px;
         }

         .telemetry2 {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            left: ]]..CFCS_LeftBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry2 > div.numbers2 {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry2 > div.numbers2 > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: right;
            width: 60px;
         }
         .telemetry2 > div.numbers2 > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: -40.4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry2 > div.numbers2 > h2 > span {
            display:block;
            font-size: 20px;
            text-align: right;
         }
         .shield
         {
            margin-left:403.2px;
            margin-top:-237.2px;
         }
         .fuel
         {
            margin-left:347px;
            margin-top:-104px;
         }
         HPcolor {
            color: ]]..HPcolor..[[;
         }
         orangecolor {
            color: #fca503;
         }
         redcolor {
            color: #fc033d;
         }
         greencolor {
            color: #2ebac9;
         }
         amcolor {
            color: ]]..AMcolor..[[;
         }
         emcolor {
            color: ]]..EMcolor..[[;
         }

         kicolor {
            color: ]]..KIcolor..[[;
         }
         thcolor {
            color: ]]..THcolor..[[;
         }
         powercolor {
            font-size: 15px;
            color: #b6dfed;
         }
         .helper {
            max-width: 24vw;
            opacity: 0.9;
            padding: 2px;
            position:fixed;
            top:8.2vh;
            left:0.5vw;
            text-align: left;
            background:  #2C2F33;
            color: #FFFFFF;
            font-family: "Times New Roman", Times, serif;
            font-size: 1.3vmin;
            border-radius: 5px;
            border: 2px solid black;
         }
         .safez {
            width: auto;
            padding: 2px;
            position:fixed;
            top:-0.1vh;
            right:0;
            text-align: right;
            color: #FFFFFF;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         .pipe {
            width: auto;
            padding-left: 35px;
            padding-right: 35px;
            padding-top: 2px;
            padding-bottom: 2px;
            position:fixed;
            top: ]]..CFCS_PipeY..[[vh;
            right: ]]..CFCS_PipeX..[[vw;
            text-align: center;
            color: ]]..CFCS_PipeText_Color..[[;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         redcolor1 {
            color: #fc033d;
         }
         greencolor1 {
            color: #6affb1;
         }
         </style>
         <div class="telemetry">
         <div class="numbers">
         <div>]]..throttle1..[[</div>
         <h2>THRUST<span>%</span></h2>
         </div>
         <div class="numbers">
         <div>]]..speed..[[</div>
         <h2>SPEED<span>Km/h</span></h2>
         </div>
         <div class="numbers">
         <div>]]..accel..[[</div>
         <h2>ACCEL<span>G</span></h2>
         </div>
         <div class="numbers">
         <div>]]..resString..[[</div>
         <h2>Brake-distance<span>]]..brakeText..[[</span></h2>
         </div>
         </div>
         <div class="telemetry2">
         <div class="numbers2">
         <div><redcolor>]]..ventCLWN..[[</redcolor> <orangecolor>]]..resCLWN..[[</orangecolor> <HPcolor>]]..shieldHP..[[</HPcolor></div>
         <h2>]]..shieldText..[[<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..fuel1..[[</div>
         <h2>FUEL<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..AMres..[[<powercolor>PW </powercolor><amcolor>]]..AMval..[[</amcolor></div>
         <h2>AM<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..EMres..[[<powercolor>PW </powercolor><emcolor>]]..EMval..[[</emcolor></div>
         <h2>EM<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..KIres..[[<powercolor>PW </powercolor><kicolor>]]..KIval..[[</kicolor></div>
         <h2>KI<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..THres..[[<powercolor>PW </powercolor><thcolor>]]..THval..[[</thcolor></div>
         <h2>TH<span>%</span></h2>
         </div>
         <div class="shield">
         <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100" fill="none" stroke="]]..shieldColor..[[" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shield"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
         </div>
         <div class="fuel">
         <svg viewBox="0 0 100 100" width="100" height="100" xmlns="http://www.w3.org/2000/svg">
         <g fill="none" fill-rule="evenodd">
         <path d="M68 63c3.038 0 5.5-2.493 5.5-5.567 0-2.05-1.833-5.861-5.5-11.433-3.667 5.572-5.5 9.383-5.5 11.433C62.5 60.507 64.962 63 68 63z" fill="#FFB12C"/>
         </g>
         </svg>
         </div>
         </div>
         <div class="safez">]]..safetext..[[</div>
         <div class="pipe">]]..pD()..[[</div>]]

      end

      if lalt == true and newhit == 0 then
         htmlm = [[
         <style>
         html, body {
            margin: 0;
            padding: 0;
            background: transparent;
            position: relative;
         }
         .telemetry {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            right: ]]..CFCS_RightBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry > div.numbers {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry > div.numbers > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: left;
            width: 60px;
         }
         .telemetry > div.numbers > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: 4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry > div.numbers > h2 > span {
            display:block;
            font-size: 20px;
         }

         .telemetry2 {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            left: ]]..CFCS_LeftBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry2 > div.numbers2 {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry2 > div.numbers2 > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: right;
            width: 60px;
         }
         .telemetry2 > div.numbers2 > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: -40.4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry2 > div.numbers2 > h2 > span {
            display:block;
            font-size: 20px;
            text-align: right;
         }
         .shield
         {
            margin-left:403.2px;
            margin-top:-237.2px;
         }
         .fuel
         {
            margin-left:347px;
            margin-top:-104px;
         }
         HPcolor {
            color: ]]..HPcolor..[[;
         }
         orangecolor {
            color: #fca503;
         }
         redcolor {
            color: #fc033d;
         }
         greencolor {
            color: #2ebac9;
         }
         amcolor {
            color: ]]..AMcolor..[[;
         }
         emcolor {
            color: ]]..EMcolor..[[;
         }

         kicolor {
            color: ]]..KIcolor..[[;
         }
         thcolor {
            color: ]]..THcolor..[[;
         }
         powercolor {
            font-size: 15px;
            color: #b6dfed;
         }
         redcolor1 {
            color: #fc033d;
         }
         greencolor1 {
            color: #6affb1;
         }
         .helper {
            max-width: 24vw;
            opacity: 0.9;
            padding: 2px;
            position:fixed;
            top:8.2vh;
            left:0.5vw;
            text-align: left;
            background:  #2C2F33;
            color: #FFFFFF;
            font-family: "Times New Roman", Times, serif;
            font-size: 1.3vmin;
            border-radius: 5px;
            border: 2px solid black;
         }
         .safez {
            width: auto;
            padding: 2px;
            position:fixed;
            top:-0.1vh;
            right:0;
            text-align: right;
            color: #FFFFFF;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         .pipe {
            width: auto;
            padding-left: 35px;
            padding-right: 35px;
            padding-top: 2px;
            padding-bottom: 2px;
            position:fixed;
            top: ]]..CFCS_PipeY..[[vh;
            right: ]]..CFCS_PipeX..[[vw;
            text-align: center;
            color: ]]..CFCS_PipeText_Color..[[;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         </style>
         <div class="telemetry">
         <div class="numbers">
         <div>]]..throttle1..[[</div>
         <h2>THRUST<span>%</span></h2>
         </div>
         <div class="numbers">
         <div>]]..speed..[[</div>
         <h2>SPEED<span>Km/h</span></h2>
         </div>
         <div class="numbers">
         <div>]]..accel..[[</div>
         <h2>ACCEL<span>G</span></h2>
         </div>
         <div class="numbers">
         <div>]]..resString..[[</div>
         <h2>Brake-distance<span>]]..brakeText..[[</span></h2>
         </div>
         </div>
         <div class="telemetry2">
         <div class="numbers2">
         <div><redcolor>]]..ventCLWN..[[</redcolor> <orangecolor>]]..resCLWN..[[</orangecolor> <HPcolor>]]..shieldHP..[[</HPcolor></div>
         <h2>]]..shieldText..[[<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..fuel1..[[</div>
         <h2>FUEL<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..AMres..[[<powercolor>PW </powercolor><amcolor>]]..AMval..[[</amcolor></div>
         <h2>AM<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..EMres..[[<powercolor>PW </powercolor><emcolor>]]..EMval..[[</emcolor></div>
         <h2>EM<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..KIres..[[<powercolor>PW </powercolor><kicolor>]]..KIval..[[</kicolor></div>
         <h2>KI<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..THres..[[<powercolor>PW </powercolor><thcolor>]]..THval..[[</thcolor></div>
         <h2>TH<span>%</span></h2>
         </div>
         <div class="shield">
         <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100" fill="none" stroke="]]..shieldColor..[[" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shield"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
         </div>
         <div class="fuel">
         <svg viewBox="0 0 100 100" width="100" height="100" xmlns="http://www.w3.org/2000/svg">
         <g fill="none" fill-rule="evenodd">
         <path d="M68 63c3.038 0 5.5-2.493 5.5-5.567 0-2.05-1.833-5.861-5.5-11.433-3.667 5.572-5.5 9.383-5.5 11.433C62.5 60.507 64.962 63 68 63z" fill="#FFB12C"/>
         </g>
         </svg>
         </div>
         </div>
         ]]..helperClass..[[
         <div class="safez">]]..safetext..[[</div>
         <div class="pipe">]]..pD()..[[</div>]]

      end

      if lalt == false and newhit == 0 then
         htmlm = [[
         <style>
         html, body {
            margin: 0;
            padding: 0;
            background: transparent;
            position: relative;
         }
         .telemetry {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            right: ]]..CFCS_RightBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry > div.numbers {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry > div.numbers > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: left;
            width: 60px;
         }
         .telemetry > div.numbers > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: 4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry > div.numbers > h2 > span {
            display:block;
            font-size: 20px;
         }

         .telemetry2 {
            width: 100vw;
            height: 100vh;
            position: fixed;
            top: ]]..CFCS_Y..[[vh;
            left: ]]..CFCS_LeftBlock_X..[[vw;
            white-space:nowrap;
            width: 400px;
         }
         .telemetry2 > div.numbers2 {
            margin-bottom: 10px;
            display: flex;
            width: 100%;
            justify-content: flex-end;
            margin-bottom: 0px;
         }
         .telemetry2 > div.numbers2 > h2 {
            font-size: 10px;
            font-weight: 900;
            margin-bottom:-3px;
            text-align: right;
            width: 60px;
         }
         .telemetry2 > div.numbers2 > div {
            font-weight: 500;
            font-size: 26px;
            text-align: right;
            color: #6affb1;
            margin-right: -40.4px;
            margin-top: ]]..CFCS_TextY..[[px;
         }
         .telemetry2 > div.numbers2 > h2 > span {
            display:block;
            font-size: 20px;
            text-align: right;
         }
         .shield
         {
            margin-left:403.2px;
            margin-top:-69px;
         }
         .fuel
         {
            margin-left:347px;
            margin-top:-104px;
         }
         HPcolor {
            color: ]]..HPcolor..[[;
         }
         orangecolor {
            color: #fca503;
         }
         redcolor {
            color: #fc033d;
         }
         greencolor {
            color: #2ebac9;
         }
         redcolor1 {
            color: #fc033d;
         }
         greencolor1 {
            color: #6affb1;
         }
         amcolor {
            color: ]]..AMcolor..[[;
         }
         emcolor {
            color: ]]..EMcolor..[[;
         }

         kicolor {
            color: ]]..KIcolor..[[;
         }
         thcolor {
            color: ]]..THcolor..[[;
         }
         powercolor {
            font-size: 15px;
            color: #b6dfed;
         }
         .helper {
            max-width: 24vw;
            opacity: 0.9;
            padding: 2px;
            position:fixed;
            top:8.2vh;
            left:0.5vw;
            text-align: left;
            background:  #2C2F33;
            color: #FFFFFF;
            font-family: "Times New Roman", Times, serif;
            font-size: 1.3vmin;
            border-radius: 5px;
            border: 2px solid black;
         }
         .safez {
            width: auto;
            padding: 2px;
            position:fixed;
            top:-0.1vh;
            right:0;
            text-align: right;
            color: #FFFFFF;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         .pipe {
            width: auto;
            padding-left: 35px;
            padding-right: 35px;
            padding-top: 2px;
            padding-bottom: 2px;
            position:fixed;
            top: ]]..CFCS_PipeY..[[vh;
            right: ]]..CFCS_PipeX..[[vw;
            text-align: center;
            color: ]]..CFCS_PipeText_Color..[[;
            font-size: 1.2em;
            font-weight: bold;
            background: ]]..CFCS_Background_Color..[[;
            border: 0.2px solid black;
         }
         </style>
         <div class="telemetry">
         <div class="numbers">
         <div>]]..throttle1..[[</div>
         <h2>THRUST<span>%</span></h2>
         </div>
         <div class="numbers">
         <div>]]..speed..[[</div>
         <h2>SPEED<span>Km/h</span></h2>
         </div>
         <div class="numbers">
         <div>]]..accel..[[</div>
         <h2>ACCEL<span>G</span></h2>
         </div>
         <div class="numbers">
         <div>]]..resString..[[</div>
         <h2>Brake-distance<span>]]..brakeText..[[</span></h2>
         </div>
         </div>
         <div class="telemetry2">
         <div class="numbers2">
         <div><redcolor>]]..ventCLWN..[[</redcolor> <orangecolor>]]..resCLWN..[[</orangecolor> <HPcolor>]]..shieldHP..[[</HPcolor></div>
         <h2>]]..shieldText..[[<span>%</span></h2>
         </div>
         <div class="numbers2">
         <div>]]..fuel1..[[</div>
         <h2>FUEL<span>%</span></h2>
         </div>
         <div class="shield">
         <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100" fill="none" stroke="]]..shieldColor..[[" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" class="feather feather-shield"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
         </div>
         <div class="fuel">
         <svg viewBox="0 0 100 100" width="100" height="100" xmlns="http://www.w3.org/2000/svg">
         <g fill="none" fill-rule="evenodd">
         <path d="M68 63c3.038 0 5.5-2.493 5.5-5.567 0-2.05-1.833-5.861-5.5-11.433-3.667 5.572-5.5 9.383-5.5 11.433C62.5 60.507 64.962 63 68 63z" fill="#FFB12C"/>
         </g>
         </svg>
         </div>
         </div>
         <div class="safez">]]..safetext..[[</div>
         <div class="pipe">]]..pD()..[[</div>]]

      end

      if mybr==true then
         system.setScreen(htmlm .. html1 .. message .. warningmsg)

      else

         system.setScreen(htmlm .. message .. warningmsg)
      end
   end
   htmlRadar = [[
   <style>
   .top-panel {
      position: absolute;
      top: 160px;
      left: 0;
      right: 0;
      height: 200px;
      transform: perspective(1920px) rotateX(-18deg);
      transform-origin: top;
      display: flex;
      justify-content: center;
   }
   .top-panel .screen-panel {
      transform-style: preserve-3d;
      transform-origin: top;
      transform: perspective(120px) rotateX(-4deg);
   }
   .screen {
      background: rgba(0, 0, 0, .5);
      border-radius: 6px;
      padding: 5px 10px 10px;
      box-sizing: border-box;
      position: relative;
   }
   .screen::after {
      content: '';
      position: absolute;
      top: -6px;
      left: -6px;
      bottom: -6px;
      right: -6px;
      background: radial-gradient(110% 160% at 50% -40%, transparent 62%, rgba(255, 255, 255, .23)), radial-gradient(100% 70% at 50% 50%, #094075 -70%, transparent);
      border-radius: 10px;
      border: 1px solid #b7b7b7;
   }
   .screen.left::after {
      background: radial-gradient(farthest-corner at -20% 100%, transparent 62%, rgba(255, 255, 255, .43)), radial-gradient(farthest-corner at 50% -250%, #094075, transparent);
   }
   .data {
      white-space: nowrap;
      text-align: right;
   }
   .screen.dividers .data:nth-child(1) {
      margin-top: 0;
      padding-top: 0;
      border-top: none;
   }
   .data {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      width: 100%;
   }
   .screen.dividers .data {
      margin-top: 4px;
      border-top: 1px solid #496d8c;
      padding-top: 4px;
   }
   .data-header {
      font-weight: bold;
      font-size: 14px;
      display: flex;
      align-items: baseline;
      justify-content: space-between;
   }
   .data-content {
      font-size: 20px;
      display: flex;
      justify-content: flex-end;
      align-items: baseline;
      font-weight: normal;
      color: #edf7ff;
      font-family: monospace;
      font-weight: bold;
   }
   .data-unit {
      font-size: 12px;
      margin-left: 2px;
      color: #94ceff;
      font-weight: bold;
   }
   .data.speed {
      position: absolute;
      top: 7px;
      left: -5px;
      z-index: 10;
      right: -5px;
      height: 100%;
   }
   .speed .data-header {
      display: flex;
      justify-content: space-between;
      margin-top: 5px;
      align-items: baseline;
   }
   .tr-mode {
      background: #e9f5ff;
      border-radius: 2px;
      font-size: 12px;
      color: black;
      padding: 1px 3px;
      font-weight: bold;
      margin-right: 5px;
      height: 14px;
   }
   .data-bar {
      height: 6px;
      background: #284965;
      margin-top: 4px;
      margin-bottom: 4px;
      overflow: hidden;
      border-radius: 10px;
   }
   .data-bar>span {
      background: linear-gradient(90deg, transparent calc(100% - 30px), #f1f9ff), repeating-linear-gradient(90deg, #82c5ff 0px, #82c5ff 2px, transparent 2px, transparent 4px);
      display: block;
      position: relative;
      width: 100%;
      height: 100%;
      border-radius: 10px;
   }
   .disabled {
      opacity: .3;
   }
   .icon {
      fill: #94ceff;
      width: 50px;
   }
   .flex {
      display: flex;
   }
   .flex.align-bottom {
      align-items: baseline;
   }
   .flex.down {
      flex-direction: column;
   }
   .flex.align-top {
      align-items: flex-start;
   }
   .flex.align-center {
      align-items: center;
   }
   .flex.justify-end {
      justify-content: flex-end;
   }
   .flex.space-between {
      justify-content: space-between;
   }
   .hologram {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      filter: drop-shadow(0px 0px 6px rgba(255, 255, 255, .23)) drop-shadow(0px 0px 20px rgba(0, 0, 0, .20));
      width: 100%;
   }
   .holo-wrap {
      transform-origin: center right;
      width: 100%;
      margin-top: 20px;
   }
   .holo-wrap .data {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
   }
   .holo-wrap .data-content {
      font-size: 12px;
   }
   .fuel-tank {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
   }
   .fuel-gauge {
      width: 160px;
      height: 5px;
      position: relative;
      background: rgba(255, 255, 255, .12);
      border-radius: 15px;
      overflow: hidden;
   }
   .fuel-gauge span {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      background: #e7f4ff;
      border-radius: 10px;
   }
   .data.icon-panel {
      display: flex;
      align-items: center;
   }
   .icon-panel .icon {
      height: 20px;
      width: auto;
      margin: 0px 0px;
      fill: rgba(200, 230, 255, .16);
   }
   .icon-panel .icon.on {
      fill: #94ceff;
   }
   .top-panel .screen-panel {
      display: flex;
      align-items: flex-start;
   }
   .screen.top-left {
      width: 470px;
      border-radius: 0px 0px 0px 6px;
      margin-right: -40px;
      height: 90px;
      padding-right: 60px;
      z-index: 0;
   }
   .top-left::after {
      background: radial-gradient(110% 160% at 70% -40%, transparent 62%, rgba(255, 255, 255, .23)), radial-gradient(100% 70% at 50% 50%, #094075 -70%, transparent);
      z-index: -1;
   }
   .screen.logo-screen {
      width: 160px;
      height: 160px;
      border-radius: 100px;
      margin-top: -40px;
      display: flex;
      justify-content: center;
      align-items: center;
      background: black;
   }
   .logo-screen::after {
      border-radius: 120px;
      background: radial-gradient(90% 136% at 50% -37%, transparent 86%, rgba(255, 255, 255, .33)), radial-gradient(100% 70% at 50% 65%, #094075 0%, transparent);
   }
   .screen.top-right {
      width: 470px;
      border-radius: 0px 0px 6px 0px;
      margin-left: -40px;
      height: 90px;
      z-index: -1;
      padding-left: 60px;
   }
   .top-right::after {
      background: radial-gradient(110% 160% at 30% -40%, transparent 62%, rgba(255, 255, 255, .23)), radial-gradient(100% 70% at 50% 50%, #094075 -70%, transparent);
      z-index: -1;
   }
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
   .needle {
      position: absolute;
      top: -6px;
      left: 50%;
      transform: translateX(-50%);
      width: 0px;
      height: 0px;
      border-left: 8px solid transparent;
      border-right: 8px solid transparent;
      border-bottom: 8px solid #ecf6ff;
      filter: drop-shadow(0px 0px 30px #94ceff) drop-shadow(0px 0px 30px #94ceff) drop-shadow(0px 0px 5px #94ceff);
      z-index: 1;
   }
   .compass {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      border-radius: 50%;
      border: 2px;
      border-style: solid;
      transform-origin: center;
      transform: rotate(0deg);
   }
   .compass span {
      font-size: 20px;
      position: absolute;
      top: 50%;
      left: 50%;
   }
   .left-panel {
      position: absolute;
      top: 300px;
      left: 50%;
      transform: perspective(1920px) translateX(-50%) translateX(-790px) rotateY(50deg) translateZ(20px);
      transform-origin: center right;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      align-items: flex-start;
      bottom: 0;
      width: 200px;
   }
   .left-panel.extended {
      width: 330px;
      transform: perspective(1920px) translateX(-50%) translateX(-700px) rotateY(50deg) translateZ(20px);
      display: block;
      top: 200px;
   }
   .pitch-roll-panel {
      position: absolute;
      top: 330px;
      border-left: 2px solid;
      left: 50%;
      transform: translateX(-50%) translateX(-465px);
      height: 300px;
      overflow: hidden;
      width: 400px;
      font-family: monospace;
      font-weight: bold;
      filter: drop-shadow(0px 0px 6px rgba(255, 255, 255, .23)) drop-shadow(0px 0px 20px rgba(0, 0, 0, .20));
   }
   .pitch {
      position: absolute;
      top: 50%;
      left: 0;
      transform: translateY(-50%);
   }
   .pitch-line {
      display: block;
      position: relative;
      height: 30px;
   }
   .pitch-line span {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: bold;
   }
   .pitch-line span::before {
      content: '';
      margin-right: 10px;
      height: 1px;
      background: #94ceff;
      flex-grow: 1;
      width: 10px;
   }
   .pitch-roll {
      position: absolute;
      top: 50%;
      left: 0;
      transform: translateY(-50%);
      display: flex;
      flex-wrap: nowrap;
      align-items: center;
   }
   .line {
      height: 2px;
      background: #c8e6ff;
      width: 90px;
   }
   .number-display {
      width: 50px;
      font-size: 16px;
      text-align: center;
      font-weight: bold;
      color: #c8e6ff;
      border: 2px solid;
      height: 21px;
      margin: 0px 8px;
      position: relative;
   }
   .number-head {
      font-size: 11px;
      position: relative;
      top: -37px;
      font-weight: bold;
   }
   .roll-lines {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%) rotate(55deg);
      width: 80px;
      height: 80px;
      border: 14px dashed rgba(200, 230, 255, .08);
      border-radius: 100px;
      border-style: dashed;
   }
   .roll-lines span {
      width: 50px;
      height: 0;
      border-bottom: 3px dashed rgba(147, 205, 254, .50);
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%) rotate(-90deg) translateX(95px);
      z-index: -1;
   }
   .roll-lines span:nth-child(2) {
      transform: translate(-50%, -50%) rotate(0deg) translateX(95px);
   }
   .roll-lines span:nth-child(3) {
      transform: translate(-50%, -50%) rotate(90deg) translateX(95px);
   }
   .roll-lines span:nth-child(4) {
      transform: translate(-50%, -50%) rotate(180deg) translateX(95px);
   }
   .ship-orientation {
      width: 100px;
      height: 100px;
      position: relative;
      margin: 30px auto 0;
      border-radius: 50%;
      border: 1px solid;
   }
   .ship-orientation-gimbal {
      width: 100px;
      height: 100px;
      position: relative;
      transform-style: preserve-3d;
      transform: rotateX(0deg) rotateY(0deg) rotateZ(0deg);
   }
   .plane-z,
   .plane-y,
   .plane-x {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      border-radius: 50%;
      transform-style: preserve-3d;
   }
   .plane-z {
      transform: rotateY(90deg);
   }
   .plane-y {
      transform: rotateX(90deg);
      border: 2px solid #9dffab;
   }
   .plane-x {
      transform: rotateZ(90deg);
   }
   .plane-z::after {
      content: '';
      position: absolute;
      top: -30px;
      bottom: -30px;
      left: 50%;
      transform: translateX(-50%);
      width: 2px;
      background: #94ceff;
      border-radius: 10px;
   }
   .orient-z-axis {
      position: absolute;
      top: -30px;
      bottom: -30px;
      width: 2px;
      background: #cce8ff;
      left: 50%;
      transform: translateX(-50%);
   }
   .orient-z-axis::before,
   .orient-z-axis::after {
      content: 'S';
      position: absolute;
      bottom: -16px;
      left: 50%;
      transform: translate(-50%, 0px);
      font-size: 13px;
      color: #c8e6ff;
   }
   .orient-z-axis::before {
      content: 'N';
      bottom: auto;
      top: -16px;
   }
   .plane-x span {
      position: absolute;
      top: 0;
      left: 0;
      bottom: 0;
      right: 0;
      border: 1px solid;
      border-radius: 50%;
   }
   .orient-x-axis {
      position: absolute;
      height: 2px;
      top: 50%;
      transform: translateY(-50%);
      left: -30px;
      right: -30px;
      background: #cce8ff;
   }
   .orient-x-axis::before,
   .orient-x-axis::after {
      content: 'W';
      position: absolute;
      left: -16px;
      top: 50%;
      transform: translate(0%, -50%);
      font-size: 13px;
      color: #c8e6ff;
   }
   .orient-x-axis::after {
      content: 'E';
      right: -16px;
      left: auto;
   }
   .ui {
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      height: 300px;
      width: 900px;
      background: rgb(0 0 0 / 53%);
      border-radius: 5px;
   }
   .ui::before {
      content: '';
      position: absolute;
      top: -6px;
      left: -6px;
      bottom: -6px;
      right: -6px;
      background: radial-gradient(110% 160% at 50% -40%, transparent 62%, rgba(255, 255, 255, .23)), radial-gradient(100% 70% at 50% 50%, #094075 -70%, transparent);
      border-radius: 10px;
      border: 1px solid #b7b7b7;
      pointer-events: none;
   }
   .top-bar {
      height: 25px;
      background: radial-gradient(50% 150% at 50% 160%, #007ae2, transparent);
      border-bottom: 1px solid rgba(148, 206, 255, .16);
      padding: 0px 10px;
      font-style: italic;
   }
   .ui-menu,
   .ui-content {
      height: 100%;
      padding: 10px;
      box-sizing: border-box;
      font-family: monospace;
   }
   .ui-content {
      width: 800px;
   }
   .ui-menu {
      width: 100px;
      background: radial-gradient(80% 120% at 50% 0%, rgba(0, 122, 226, .30), transparent);
      border-right: 1px solid rgba(148, 206, 255, .16);
      padding: 0;
   }
   .ui-menu>div {
      padding: 20px 20px 20px;
      font-size: 16px;
      text-align: left;
      border-bottom: 1px solid rgba(148, 206, 255, .20);
   }
   .ui-menu>div.active {
      background: radial-gradient(70% 50% at 100% 50%, rgba(0, 134, 247, .95), transparent);
      color: #87c8ff;
   }
   span.query {
      padding: 2px 4px;
      background: #294256;
   }
   .system-map {
      position: absolute;
      top: 0;
      width: 100%;
      height: 100%;
      background: rgba(7, 44, 82, .81);
      left: 0;
   }
   .planet {
      width: 20px;
      height: 20px;
      border-radius: 50%;
      border: 2px solid;
      box-sizing: border-box;
      background: rgba(148, 206, 255, .29);
   }
   .map-actual {
      position: absolute;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      transform-style: preserve-3d;
   }
   .map-center {
      position: absolute;
      content: '';
      width: 2000px;
      height: 2000px;
      top: 50%;
      left: 50%;
      background: repeating-radial-gradient(rgba(0, 17, 35, .23), transparent 112px), repeating-radial-gradient(rgba(148, 206, 255, .34), transparent 75%);
      border-radius: 50%;
   }
   .map-pin {
      position: absolute;
      top: 50%;
      left: 50%;
   }
   .map-pin .icon,
   .map-pin .planet {
      height: 30px;
      width: 30px;
   }
   .pin-data {
      position: absolute;
      bottom: 100%;
      margin-bottom: 10px;
      white-space: nowrap;
      text-align: center;
      width: 200px;
      left: 50%;
      transform: translateX(-50%);
   }
   .pin-data .name {
      font-size: 16px;
      color: white;
      line-height: 16px;
   }
   .pin-data .units {
      font-family: monospace;
      font-size: 14px;
      font-weight: bold;
      line-height: 14px;
   }
   .map-pin.player {
      filter: drop-shadow(0px 0px 20px #edf7ff);
   }
   .map-pin.player .icon {
      fill: #ffde56;
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
   function drawMap()
      asteroid=""
      planet=""
      asterunits=""
      asternumbers=""
      local html5 = ''
      if map == 0 then return html end

      html5 = [[
      <div class="system-map">
      <div class="map-actual" style="transform: perspective(1920px) translateZ(-250px);">
      <div class="map-center" style="transform: translate(-50%, -50%) rotateX(]]..yDelta..[[deg) rotateY(0deg) rotateZ(]]..xDelta..[[deg);"></div>
      ]]

      for k,v in pairs(helios) do
         local planetBody = helios[v.bodyId]

         local planetName = string.upper(v.name[1])
         local typeplanet = string.upper(v.type[1])

         local distance = customDistance(planetBody:getDistance(core.getConstructWorldPos()))

         local coords = {x=v.center.x + (-v.center.x * mapScale), y=v.center.y + (-v.center.y * mapScale), z=v.center.z + (-v.center.z * mapScale)}
         rotateY3D(coords, xDelta)
         rotateX3D(coords, yDelta)
         local mainPlanet = true;
         local size = planetScale

         if planetBody:getDistance(core.getConstructWorldPos()) > 12000000 then
            size = planetScale
         else
            size = aliothsize
         end
         local display = "block"
         if string.find(typeplanet, 'MOON') ~= nil then
            size = moonScale
            display = "none"
         end

         local planet = [[
         <div class="map-pin" style="display: ]]..display..[[; transform: translate(-50%, -50%) translateX(]]..coords.x..[[px) translateY(]]..coords.y..[[px) translateZ(]]..coords.z..[[px);">
         <div class="pin-data" style="display: ]]..display..[[;">
         <div class="name">]]..planetName..[[</div>
         <div class="units">]]..distance..[[</div>
         </div>
         <div class="planet" style="width: ]]..(v.radius/size)..[[px; height: ]]..(v.radius/size)..[[px;"></div>
         </div>
         ]]

         html5 = html5 .. planet
      end

      local shipPosition = core.getConstructWorldPos()
      local shipCoords = {x=shipPosition[1] + (-shipPosition[1] * mapScale), y=shipPosition[2] + (-shipPosition[2] * mapScale), z=shipPosition[3] + (-shipPosition[3] * mapScale)}
      rotateY3D(shipCoords, xDelta)
      rotateX3D(shipCoords, yDelta)

      local playerPosition = [[
      <div class="map-pin player" style="transform: translate(-50%, -50%) translateX(]]..shipCoords.x..[[px) translateY(]]..shipCoords.y..[[px) translateZ(]]..shipCoords.z..[[px);">
      <div class="pin-data">
      <div class="name"></div>
      </div>
      ]]..icons.ship()..[[
      </div>
      ]]
      html5 = html5.. playerPosition

      if asteroidPOS ~= "" then
         local shipPosition = asteroidcoord
         local distance = customDistance((vec3(shipPosition) - vec3(core.getConstructWorldPos())):len())
         local asteroidC = {x=shipPosition[1] + (-shipPosition[1] * mapScale), y=shipPosition[2] + (-shipPosition[2] * mapScale), z=shipPosition[3] + (-shipPosition[3] * mapScale)}
         rotateY3D(asteroidC, xDelta)
         rotateX3D(asteroidC, yDelta)
         local shipPosition = [[
         <div class="map-pin" style="transform: translate(-50%, -50%) translateX(]]..asteroidC.x..[[px) translateY(]]..asteroidC.y..[[px) translateZ(]]..asteroidC.z..[[px);">
         <div class="pin-data">
         <div class="name">]]..markerName..[[</div>
         <div class="units">]]..distance..[[</div>
         </div>
         <div class="warp-scan"></div>
         </div>
         ]]
         html5 = html5..shipPosition..'</div></div>'
      end

      html5 = html5 .. '</div></div>'

      return html5
   end
   local function signedAngleBetween(vec1, vec2, planeNormal)
      local normVec1 = vec1:normalize()
      local normVec2 = vec2:normalize()
      local cosAngle = normVec1:dot(normVec2)
      cosAngle = utils.clamp(cosAngle, -1, 1)
      local angle = math.acos(cosAngle)
      local crossProduct = vec1:cross(vec2)
      if crossProduct:dot(planeNormal) < 0 then
         return -angle - math.pi
      else
         return angle + math.pi
      end
   end
   local function directionToBearing (direction, worldVertical)
      local north = vec3(0, 0, 1)
      local northOnGround = north:project_on_plane(worldVertical)
      local directionOnGround = direction:project_on_plane(worldVertical)
      return signedAngleBetween(northOnGround, directionOnGround, worldVertical)
   end
   function rotateX3D(point, theta)
      theta = theta * math.pi / 180
      local sinTheta = math.sin(theta);
      local cosTheta = math.cos(theta);
      local y = point.y * cosTheta - point.z * sinTheta
      local z = point.z * cosTheta + point.y * sinTheta
      point.y = y
      point.z = z
      return point
   end
   function rotateY3D(point, theta)
      theta = theta * math.pi / 180
      local sinTheta = math.sin(theta);
      local cosTheta = math.cos(theta);
      local x = point.x * cosTheta - point.y * sinTheta
      local y = point.y * cosTheta + point.x * sinTheta
      point.x = x
      point.y = y
      return point
   end
   function rotateZ3D(point, theta)
      theta = theta * math.pi / 180
      local sinTheta = math.sin(theta);
      local cosTheta = math.cos(theta);
      local x = point.x * cosTheta + point.z * sinTheta
      local z = point.z * cosTheta - point.x * sinTheta
      point.x = x
      point.y = y
      return point
   end

   unit.setTimer("shield",1)
   unit.setTimer("braketime",0.15)
   unit.setTimer("hud",0.02)
   unit.setTimer("prealarm",2)
   if collectgarbages == true then
      unit.setTimer("cleaner",30)
   end