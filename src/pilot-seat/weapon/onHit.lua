local damage1 = math.floor(damage)
if GHUD_show_hits == true then
hitAnimations = hitAnimations + 1
lastHitTime[hitAnimations] = {damage = damage1, time = 0, hitOpacity = 1, anims = hitAnimations}
end
if totalDamage[targetId] ~= nil then --target damage calculation concept (DeadRank)
    totalDamage[targetId].damage = totalDamage[targetId].damage + damage1
else
    totalDamage[targetId] = {damage = damage1}
end