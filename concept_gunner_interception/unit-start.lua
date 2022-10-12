local check = pcall(require,'autoconf/custom/DUPIRATE/vector')
if not check then
system.print("You won't get my code")
for slot_name, slot in pairs(unit) do
    if
        type(slot) == "table"
        and type(slot.export) == "table"
        and slot.getElementClass
    then
        if slot.getElementClass():lower():find("core") then
             core = slot
        end
        if slot.getElementClass():lower():find("databank") then
             db = slot
        end    
        if slot.getElementClass():lower():find("screen") then
             screen = slot
        end   
    end
    end
db.clear()
screen.clear()
unit.exit()
end
shift = false
exportMode = true --export: Coordinate export mode
timeZone = 3 --export: from 1 to 24
targetSpeed = 29999 --export: Target speed
atlas = require("atlas")
start(unit,system,text)