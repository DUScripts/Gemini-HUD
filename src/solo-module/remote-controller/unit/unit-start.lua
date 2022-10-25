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
formatted_hp = string.format('%0.0f',math.ceil(HP))
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

unit.setTimer('hud',0.02)