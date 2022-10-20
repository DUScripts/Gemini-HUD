local damage1 = hitdamage*
local randomNumber = math.random(10000, 1000000)
hitAnimations = hitAnimations + 1
lastHitTime['w'..damage1..randomNumber] = {damage = damage1, time = 0, hitOpacity = 1, anims = hitAnimations}
unit.setTimer('w'..damage1..randomNumber, 0.016)