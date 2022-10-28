start:
Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, 1.0)
if tz1 ~= 2 then tz2=1 end
if tz1 == 1 and tz2 == 1 then tz1=2 mybr = true end
if altb==false then buttonSpace=true end

stop:
Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, -1.0)
Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
buttonSpace=false