local damage1 = math.floor(damage)

local ammo = ''
if weapon_.isOutOfAmmo() ~= 1 then --weapon slot name
    ammo = weapon_.getAmmo()
    ammo = system.getItem(ammo)['displayName']
    if ammo:match("Antimatter") then
        ammo = "AM"
     elseif ammo:match("Electromagnetic") then
        ammo = "EM"
     elseif ammo:match("Kinetic") then
        ammo = "KI"
     elseif ammo:match("Thermic") then
        ammo = "TH"
     end
end

if GHUD_show_hits == true then
hitAnimations = hitAnimations + 1
local strd = 'HIT '..ammo..' '..damage1
lastHitTime[hitAnimations] = {damage = strd, time = 0, hitOpacity = 1, anims = hitAnimations}
end
if totalDamage[targetId] ~= nil then --target damage calculation concept (DeadRank)
    totalDamage[targetId].damage = totalDamage[targetId].damage + damage1
else
    totalDamage[targetId] = {damage = damage1}
end