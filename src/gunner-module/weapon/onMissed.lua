local miss = math.random(10000,1000000)
missAnimations = missAnimations + 1
lastMissTime['m'..miss] = {time = 0, missOpacity = 1, anims = missAnimations}
unit.setTimer('m'..miss, 0.016)