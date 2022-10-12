--events
onHit:
damage[targetDamage] = targetDamage
lastHitTime[targetDamage] = system.getArkTime()
hitOpacity = 1
hit = true

onMissed:
lastMissTime = system.getArkTime()
missOpacity = 1
miss = true

onDestroyed:
dHint = 'Target has been destroyed!'

