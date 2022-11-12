start:
Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, 1.0)
if altb==false then buttonSpace=true end
upB = true
if gearB == true then
    helper1 = not helper
end

stop:
Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, -1.0)
Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
buttonSpace=false
upB = false
helper1 = not helper1