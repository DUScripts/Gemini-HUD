local miss = math.random(51000-100000)
lastMissTime['m'..miss] = {time = system.getArkTime(), missOpacity = 1}
unit.setTimer('m'..miss, 0.016)
system.print('m'..miss)