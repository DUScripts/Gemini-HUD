function missionTax(system,radar)
    local id = radar.getTargetId()
    local dist = radar.getConstructDistance(id)
    local forwvector = vec3(system.getCameraWorldForward())
    local worldpos = vec3(system.getCameraWorldPos())
    local pos = (dist * forwvector + worldpos)
    local x,y,z = pos:unpack()
    local wayp = '::pos{0,0,'..x..','..y..','..z..'}'
    system.setWaypoint(wayp)
return wayp
end