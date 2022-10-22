local miss = math.random(10000,1000000)
missAnimations = missAnimations + 1
lastMissTime['k'..miss] = {time = 0, missOpacity = 1, anims = missAnimations}
unit.setTimer('k'..miss, 0.016)