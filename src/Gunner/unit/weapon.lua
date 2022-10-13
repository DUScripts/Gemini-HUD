--events
onHit:
local damage1 = math.random(10000,50000)
lastHitTime['h'..damage1] = {damage = damage1, time = system.getArkTime()}
unit.setTimer('h'..damage1, 0.016)
system.print('h'..damage1)

onMissed:
local miss = math.random(51000-100000)
lastMissTime['m'..miss] = {time = system.getArkTime()}
unit.setTimer('m'..miss, 0.016)
system.print('m'..miss)

onDestroyed:
dHint = 'Target has been destroyed!'

