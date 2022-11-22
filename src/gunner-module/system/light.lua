start:
if databank_1.getStringValue(15) ~= "" then
    local way = databank_1.getStringValue(15)
    system.setWaypoint(way)
end