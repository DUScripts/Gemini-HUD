local damage1 = damage
hitAnimations = hitAnimations + 1
lastHitTime[hitAnimations] = {damage = damage1, time = 0, hitOpacity = 1, anims = hitAnimations}
if totalDamage[targetId] ~= nil then --target damage calculation concept
    totalDamage[targetId].damage = totalDamage[targetId].damage + damage1
else
    totalDamage[targetId] = {damage = damage1}
end