loop:
map = 1
system.lockView(1)
local gmap = mapGalaxy .. drawMap()
xDelta = xDelta + system.getMouseDeltaX()
yDelta = yDelta + system.getMouseDeltaY()
system.setScreen(gmap)

stop:
map = 0
system.lockView(0)

