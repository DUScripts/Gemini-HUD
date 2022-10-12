--events
onHit:
damage = targetDamage
lastHitTime = system.getArkTime()
hitOpacity = 1
hit = true

onMissed:
lastMissTime = system.getArkTime()
missOpacity = 1
miss = true

onDestroyed:
dHint = 'Target has been destroyed!'

