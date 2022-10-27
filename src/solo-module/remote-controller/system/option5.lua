loop:
map = 1
xDelta = xDelta + system.getMouseDeltaX()
yDelta = yDelta + system.getMouseDeltaY()
system.setScreen(drawMap())

stop:
map = 0

