start:
local DepartureWaypoint = "::pos{0,0," ..math.floor(DepartureCenter.x)..","..math.floor(DepartureCenter.y)..","..math.floor(DepartureCenter.z).."}"
if lalt==true then
   system.print(DepartureCenterName)
   system.setWaypoint(DepartureWaypoint)
else
   system.print(stellarObjects[sortestPipeKey2Id].name[1])
   system.setWaypoint("::pos{0,0," ..math.floor(stellarObjects[sortestPipeKey2Id].center[1]).. "," ..math.floor(stellarObjects[sortestPipeKey2Id].center[2]).. "," ..math.floor(stellarObjects[sortestPipeKey2Id].center[3]).. "}")
end
--if buttonSpace == true then
--    local pos = system.getWaypointFromPlayerPos()
--    system.print(pos)
--end