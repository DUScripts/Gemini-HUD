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
inTEXT(unit,system,text)