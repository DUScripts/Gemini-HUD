local damage1 = damage
local randomNumber = math.random(10000, 1000000)
hitAnimations = hitAnimations + 1
lastHitTime['w'..damage1..randomNumber] = {damage = damage1, time = 0, hitOpacity = 1, anims = hitAnimations}
if totalDamage[targetId] ~= nil then --target damage calculation concept
    totalDamage[targetId].damage = totalDamage[targetId].damage + damage1
else
    totalDamage[targetId] = {damage = damage1}
end
unit.setTimer('w'..damage1..randomNumber, 0.016)