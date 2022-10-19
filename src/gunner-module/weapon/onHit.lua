local damage1 = hitdamage*
lastHitTime['h'..damage1] = {damage = damage1, time = system.getArkTime(), hitOpacity = 1}
unit.setTimer('h'..damage1, 0.016)
system.print('h'..damage1)