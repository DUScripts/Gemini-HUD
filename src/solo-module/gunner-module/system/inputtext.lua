local count = #string.gsub(text, "[^f]", "")
local f1 = string.sub(text,1,1)
if count == 1 and f1 == "f" then
   mRadar:onTextInput(text)
end
if text == "export" then GEAR(unit,system,text) end
if text == "clear" then
   databank_2.clear()
   GHUD_friendly_IDs = {}
   newWhitelist = checkWhitelist()
   whitelist = newWhitelist
   system.print('Databank whitelist cleared')
end
if text == "addall" then
   local keys = databank_2.getNbKeys()
   local keyCount = keys
for k,v in pairs(radarIDs) do
    keyCount = keyCount + 1
    databank_2.setIntValue(keyCount,v)
    table.insert(GHUD_friendly_IDs,v)
 end
 newWhitelist = checkWhitelist()
 whitelist = newWhitelist
 system.print('All targets have been added to the whitelist')
end
inTEXT(unit,system,text)