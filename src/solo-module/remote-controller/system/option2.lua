start:
local DestWaypoint = "::pos{0,0," ..math.floor(DestinationCenter.x)..","..math.floor(DestinationCenter.y)..","..math.floor(DestinationCenter.z).."}"
if lalt==false then
   system.print(DestinationCenterName)
   system.setWaypoint(DestWaypoint)
else
   system.print(stellarObjects[sortestPipeKeyId].name[1])
   system.setWaypoint("::pos{0,0," ..math.floor(stellarObjects[sortestPipeKeyId].center.x).. "," ..math.floor(stellarObjects[sortestPipeKeyId].center.y).. "," ..math.floor(stellarObjects[sortestPipeKeyId].center.z).. "}")
end