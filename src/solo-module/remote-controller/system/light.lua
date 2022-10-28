start:
if databank.getStringValue(15) ~= "" then
    local way = db.getStringValue(15)
    system.setWaypoint(way)
end