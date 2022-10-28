start:
Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, -1.0)
if altb==false then buttonC=true end

stop:
Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, 1.0)
Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
buttonC=false