start:
Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, -1.0)
if altb==false then buttonC=true end
downB = true
if gearB == true then
    helper = not helper
    system.setScreen(helpHTML)
end

stop:
Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, 1.0)
Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
buttonC=false
downB = false
helper = not helper